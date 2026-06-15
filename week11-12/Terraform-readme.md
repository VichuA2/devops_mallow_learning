# AWS Production Deployment: Terraform Infrastructure Guide

A comprehensive reference covering Terraform IaC, Docker containerization, Amazon ECS EC2 launch type, RDS MySQL, and CI/CD pipeline automation for two production applications — a Ruby on Rails movie review system and a Laravel PHP food ordering system.

---

## Table of Contents

1. [Terraform Infrastructure as Code](#1-terraform-infrastructure-as-code)
2. [Docker & Containerization](#2-docker--containerization)
3. [Amazon ECS — EC2 Launch Type](#3-amazon-ecs--ec2-launch-type)
4. [CI/CD with AWS CodePipeline & CodeBuild](#4-cicd-with-aws-codepipeline--codebuild)
5. [Supporting Services](#5-supporting-services)

---

## 1. Terraform Infrastructure as Code

### 1.1 What is Terraform?

Terraform is an open-source Infrastructure as Code (IaC) tool by HashiCorp. It lets you define cloud resources in declarative `.tf` configuration files and manage their full lifecycle — create, update, and destroy — through a consistent CLI workflow.

**Key principle:** You describe the *desired state* of your infrastructure. Terraform figures out what needs to be created, changed, or deleted to reach that state.

### 1.2 Core Concepts

#### Providers
Plugins that allow Terraform to interact with a cloud platform's API. For this project:
```hcl
provider "aws" {
  region = "ap-south-1"
}
```

#### Resources
The fundamental building blocks — an individual piece of infrastructure:
```hcl
resource "aws_vpc" "vishnu_terraform_vpc_ror" {
  cidr_block = "10.30.0.0/16"
}
```

#### Variables
Input values that make configurations reusable across environments:
```hcl
variable "aws_region" {
  default = "ap-south-1"
}
```
Sensitive values (passwords, tokens) are passed via environment variables:
```bash
export TF_VAR_db_password="MySecurePassword"
```

#### Outputs
Values exposed after `terraform apply` — useful for referencing resource attributes:
```hcl
output "alb_dns_name" {
  value = aws_lb.vishnu_terraform_alb_ror.dns_name
}
```

#### State
Terraform maintains a `terraform.tfstate` file that maps configuration to real infrastructure. For this project, state is stored remotely in S3:
```hcl
backend "s3" {
  bucket  = "my-terraform-state-vichu"
  key     = "vishnu-terraform/terraform.tfstate"
  region  = "ap-south-1"
  encrypt = true
}
```

Remote state enables team collaboration and prevents state file conflicts.

### 1.3 Terraform Workflow

```
terraform init     # Download providers, configure backend
terraform plan     # Preview changes — what will be created/changed/destroyed
terraform apply    # Execute the plan and provision resources
terraform destroy  # Tear down all managed resources
```

Always run `terraform plan` before `apply` — it shows exactly what will change without making any real modifications.

### 1.4 Naming Convention

All resources in this project follow a consistent naming pattern:

```
vishnu_terraform_<resource_type>_ror
```

Examples:
- `vishnu_terraform_vpc_ror`
- `vishnu_terraform_sg_alb_ror`
- `vishnu_terraform_ecs_cluster_ror`
- `vishnu_terraform_rds_php` (PHP-specific suffix where needed)

Consistent naming makes resources easy to identify in the AWS console and prevents confusion with manually created resources (`vishnu-manual-*`).

### 1.5 Project File Structure

| File | What it provisions |
|---|---|
| `main.tf` | Provider configuration, S3 backend |
| `variables.tf` | All input variables with defaults |
| `outputs.tf` | Key resource values exposed post-apply |
| `vpc.tf` | VPC, public/private subnets, IGW, NAT gateways, route tables, NACLs |
| `security_groups.tf` | SGs for ALB, ECS, RDS, Bastion |
| `ec2.tf` | Bastion host with Elastic IP |
| `rds.tf` | Shared RDS MySQL instance, subnet group, parameter group |
| `ecr.tf` | ECR repositories for both apps with lifecycle policies |
| `iam.tf` | IAM roles for ECS tasks, EC2 instances, CodeBuild, CodePipeline |
| `alb.tf` | ALB, target groups, HTTP→HTTPS redirect, host-based routing |
| `acm.tf` | ACM SSL certificate with DNS validation, Route 53 A records |
| `ecs.tf` | ECS cluster, launch template, ASG, task definitions, services |
| `asg.tf` | App Auto Scaling policies (CPU + Memory target tracking) |
| `cloudwatch.tf` | Log groups, SNS topic, CloudWatch dashboard, metric alarms |
| `s3.tf` | CodePipeline artifact bucket with encryption and lifecycle rules |
| `codebuild.tf` | CodeBuild projects for both apps |
| `codepipeline.tf` | CodePipeline with Source → Build → Deploy stages + GitHub webhooks |

---

## 2. Docker & Containerization

### 2.1 Why Docker for ECS?

ECS runs applications as Docker containers. Before deploying to ECS, each application must be packaged into a Docker image and stored in Amazon ECR (Elastic Container Registry).

**Workflow:**
```
Write Dockerfile → docker build → docker push to ECR → ECS pulls and runs
```

### 2.2 Ruby on Rails Dockerfile

```dockerfile
FROM ruby:3.0.4

RUN apt-get update -qq && apt-get install -y \
    build-essential nodejs npm \
    default-libmysqlclient-dev curl git

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY package.json ./
RUN npm install --legacy-peer-deps

COPY . .

RUN mkdir -p tmp/pids tmp/cache tmp/sockets log

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3000
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
```

**Key decisions:**
- `bundle install` before `COPY . .` — gems are cached as a separate layer, so code changes don't re-install gems.
- `mkdir -p tmp/pids` — Puma requires this directory to write its PID file; without it the container crashes on startup.
- `entrypoint.sh` runs `db:migrate` before starting Puma.

### 2.3 Laravel / PHP Dockerfile

```dockerfile
FROM php:8.3-apache

RUN apt-get update && apt-get install -y \
    git unzip zip curl libzip-dev libpng-dev \
    libonig-dev libxml2-dev default-mysql-client \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs

WORKDIR /var/www/html
COPY food-app/ .
COPY food-app/apache.conf /etc/apache2/sites-available/000-default.conf

RUN composer install --no-dev --optimize-autoloader
RUN composer dump-autoload --optimize
RUN npm install && npm run build

RUN mkdir -p storage/framework/{views,cache,sessions} bootstrap/cache
RUN chown -R www-data:www-data storage bootstrap/cache
RUN a2enmod rewrite

EXPOSE 80
CMD ["sh", "-c", "php artisan config:clear && php artisan migrate --force && php artisan db:seed --class=RolePermissionSeeder --force && apache2-foreground"]
```

**Key decisions:**
- `composer install --no-dev` — excludes development packages to reduce image size.
- `composer dump-autoload` — regenerates the autoloader so service providers (including Spatie roles) are discovered.
- Seeder runs on startup — ensures the `Customer` role exists in the database.
- `food-app/` subdirectory — the Laravel app lives in a subdirectory of the repo, so the Dockerfile is placed at the repo root and copies `food-app/` in.

### 2.4 .dockerignore

Always add `.dockerignore` to exclude large directories from the build context:

```
node_modules
.git
log
tmp
```

Without this, Docker copies `node_modules` (often 500MB+) into the build context on every build, making builds slow even when nothing changed.

### 2.5 ENTRYPOINT vs CMD

| | ENTRYPOINT | CMD |
|---|---|---|
| Purpose | Fixed executable that always runs | Default arguments, easily overridden |
| Override at runtime | Only with `--entrypoint` flag | Any argument passed to `docker run` |
| Best for | Containers with a single purpose | Providing sensible defaults |

**Pattern used in this project:**
```dockerfile
ENTRYPOINT ["/entrypoint.sh"]   # always runs migrations first
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]  # default server command
```

The entrypoint script ends with `exec "$@"` — this replaces the shell process with the CMD process, ensuring the app receives Unix signals (SIGTERM) correctly for graceful shutdown.

### 2.6 ECR — Elastic Container Registry

ECR is AWS's managed Docker image registry. Benefits over Docker Hub:
- Integrated IAM authentication — no separate credentials needed.
- Images stay within the AWS network — faster pulls from ECS.
- Lifecycle policies automatically clean up old images.

**Commands used:**
```bash
# Authenticate
aws ecr get-login-password --region ap-south-1 | \
  docker login --username AWS --password-stdin \
  782208973532.dkr.ecr.ap-south-1.amazonaws.com

# Build, tag, push
docker build -t <ecr-url>/vishnu-terraform/movie-ror:latest .
docker push <ecr-url>/vishnu-terraform/movie-ror:latest
```

---

## 3. Amazon ECS — EC2 Launch Type

### 3.1 ECS Concepts

| Concept | Description |
|---|---|
| **Cluster** | Logical grouping of compute resources for running tasks |
| **Task Definition** | Versioned JSON blueprint — container image, CPU, memory, ports, env vars |
| **Task** | One running instance of a task definition |
| **Service** | Maintains desired task count; handles deployments and restarts |
| **Capacity Provider** | Defines what compute backs the cluster (EC2 ASG or Fargate) |

### 3.2 EC2 vs Fargate Launch Types

This project uses **EC2 launch type** — EC2 instances run inside the cluster and host the containers.

| | EC2 Launch Type | Fargate |
|---|---|---|
| Infrastructure | You manage EC2 instances | AWS manages compute |
| Network mode | `bridge` (dynamic ports) or `awsvpc` | `awsvpc` only |
| Cost | Pay for EC2 instances | Pay per task vCPU/memory second |
| Control | Full OS access, SSH into instances | No server access |
| Startup time | Faster (instances already running) | Slightly slower (cold start) |

**Why EC2 for this project:** Learning the full stack — managing instances, understanding port mapping, and working with capacity providers provides deeper insight than Fargate's abstraction.

### 3.3 Bridge Network Mode & Dynamic Port Mapping

With EC2 bridge mode, containers use **dynamic port mapping**:
- The container runs on a fixed port internally (e.g., 3000 for Puma).
- The host EC2 instance assigns a random port from the ephemeral range (32768–65535).
- The ALB discovers this dynamic port via ECS integration.

```hcl
portMappings = [{
  containerPort = 3000
  hostPort      = 0       # 0 = dynamic
  protocol      = "tcp"
}]
```

The Security Group for ECS must allow the full dynamic port range from the ALB:
```hcl
ingress {
  from_port       = 32768
  to_port         = 65535
  security_groups = [aws_security_group.alb_sg.id]
}
```

### 3.4 ECS with EC2 Auto Scaling Group

Rather than fixed EC2 instances, this project uses an **ASG-backed capacity provider**:

```
ECS Cluster
  └── Capacity Provider
        └── Auto Scaling Group
              └── Launch Template (ECS-optimised AMI)
                    └── EC2 Instances (auto-register to cluster via user_data)
```

The `user_data` in the launch template registers instances to the cluster:
```bash
echo ECS_CLUSTER=vishnu-terraform-shared-ecs-cluster-ror >> /etc/ecs/ecs.config
```

**Managed Scaling** — ECS automatically adjusts the ASG size based on how many tasks need to be placed, targeting 80% capacity utilisation.

### 3.5 Task Definitions

Task definitions are versioned blueprints. Key fields configured in this project:

```hcl
resource "aws_ecs_task_definition" "ror_task" {
  family                   = "vishnu-terraform-ror-task"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.task_exec_role.arn

  container_definitions = jsonencode([{
    name  = "movie-ror-container"
    image = "${ecr_url}:latest"
    portMappings = [{ containerPort = 3000, hostPort = 0 }]
    environment = [
      { name = "RAILS_ENV",        value = "production" },
      { name = "DATABASE_URL",     value = "mysql2://..." },
      { name = "SECRET_KEY_BASE",  value = "..." }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/vishnu-terraform-ror-task"
        "awslogs-region"        = "ap-south-1"
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}
```

### 3.6 ECS Services

Services ensure a desired number of tasks are always running:

```hcl
resource "aws_ecs_service" "ror_service" {
  name            = "vishnu-terraform-ror-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.ror_task.arn
  desired_count   = 1
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = aws_lb_target_group.ror_tg.arn
    container_name   = "movie-ror-container"
    container_port   = 3000
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true   # auto-rollback on failed deployment
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
    # CodePipeline manages these — Terraform shouldn't overwrite them
  }
}
```

### 3.7 App Auto Scaling

Two scaling policies per service — scale on CPU and Memory:

```hcl
resource "aws_appautoscaling_policy" "cpu_scaling" {
  policy_type = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = 70.0   # maintain CPU at 70%
    scale_in_cooldown  = 300    # wait 5 min before scaling in
    scale_out_cooldown = 60     # scale out quickly

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
```

**Target Tracking** — AWS automatically adds or removes tasks to maintain the target metric value, similar to a thermostat.

### 3.8 Deployment Circuit Breaker

Prevents failed deployments from cycling indefinitely:
- If a new deployment fails to reach a healthy state (tasks keep crashing), ECS automatically rolls back to the previous task definition revision.
- Without this, ECS would keep retrying failed tasks until manually stopped.

---

## 4. CI/CD with AWS CodePipeline & CodeBuild

### 4.1 Pipeline Architecture

```
GitHub (terraform-migration branch)
          │
          ▼ (webhook on push)
   ┌─────────────────────┐
   │     CodePipeline     │
   │                      │
   │  Stage 1: Source ────┼──► Pulls code from GitHub → S3 artifact
   │                      │
   │  Stage 2: Build  ────┼──► CodeBuild
   │                      │      ├── docker build
   │                      │      ├── docker push → ECR
   │                      │      └── imagedefinitions.json → S3
   │                      │
   │  Stage 3: Deploy ────┼──► ECS rolling update
   └─────────────────────┘
```

### 4.2 buildspec.yml

The `buildspec.yml` file at the repo root tells CodeBuild what to do:

```yaml
version: 0.2
phases:
  pre_build:
    commands:
      - aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login \
          --username AWS --password-stdin \
          $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
      - export REPOSITORY_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME
      - export IMAGE_TAG=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
  build:
    commands:
      - docker build -t $REPOSITORY_URI:$IMAGE_TAG .
      - docker tag $REPOSITORY_URI:$IMAGE_TAG $REPOSITORY_URI:latest
  post_build:
    commands:
      - docker push $REPOSITORY_URI:$IMAGE_TAG
      - docker push $REPOSITORY_URI:latest
      - printf '[{"name":"%s","imageUri":"%s"}]' "$ECS_CONTAINER_NAME" "$REPOSITORY_URI:$IMAGE_TAG" > imagedefinitions.json
artifacts:
  files:
    - imagedefinitions.json
```

**Key variables** — injected by Terraform into CodeBuild environment:
- `AWS_ACCOUNT_ID` — AWS account number (not `ACCOUNT_ID` — common mistake)
- `IMAGE_REPO_NAME` — ECR repository name
- `ECS_CONTAINER_NAME` — must exactly match container name in task definition

**imagedefinitions.json** — tells CodePipeline's Deploy stage which container to update with the new image:
```json
[{"name": "movie-ror-container", "imageUri": "123456789.dkr.ecr.ap-south-1.amazonaws.com/vishnu-terraform/movie-ror:abc1234"}]
```

### 4.3 GitHub Integration

This project uses **GitHub OAuth v1** (not CodeStar Connections) because CodeStar Connections is unavailable in `ap-south-1`:

```hcl
action {
  provider = "GitHub"
  version  = "1"
  configuration = {
    Owner      = "VichuA2"
    Repo       = "movie-review-system"
    Branch     = "terraform-migration"
    OAuthToken = var.github_oauth_token
    PollForSourceChanges = false   # use webhook instead
  }
}
```

A webhook is also configured so pushes trigger the pipeline immediately rather than polling every minute.

### 4.4 IAM Permissions Required

CodePipeline needs specific permissions for each stage:

| Stage | Permissions Needed |
|---|---|
| Source | S3 read/write (artifact bucket) |
| Build | CodeBuild start/get, S3 read/write |
| Deploy | ECS UpdateService, RegisterTaskDefinition, DescribeServices, IAM PassRole |

Missing `iam:PassRole` or ECS permissions cause the Deploy stage to fail with "insufficient permissions" — a common error when setting up pipelines.

### 4.5 Pipeline Execution Modes

| Mode | Behaviour | Best For |
|---|---|---|
| **Superseded** | New run cancels the current one | Active development |
| **Queued** | Runs execute one at a time in order | Production deployments |
| **Parallel** | All runs execute simultaneously | Not recommended for deployments |

**This project uses Queued** — every commit gets its own deployment in sequence, ensuring no deployments are skipped or race with each other.

---

## 5. Supporting Services

### 5.1 VPC & Networking

```
VPC: 10.30.0.0/16
  ├── Public Subnets (10.30.1.0/24, 10.30.2.0/24)  — ALB, Bastion, NAT GW
  └── Private Subnets (10.30.3.0/24, 10.30.4.0/24) — ECS tasks, RDS
```

**NAT Gateways** — allow ECS tasks in private subnets to pull images from ECR and reach the internet (e.g., for gem/package downloads during builds) without being directly accessible from the internet.

**NACLs vs Security Groups:**
- Security Groups — stateful, operate at the instance/ENI level, allow rules only.
- NACLs — stateless, operate at the subnet level, have both allow and deny rules. Inbound and outbound rules must both be configured.

### 5.2 Application Load Balancer

The shared ALB routes traffic to both apps using **host-based routing**:

```
HTTPS:443 →
  movie.vichubro.online  → Target Group (port 3000) → RoR ECS tasks
  food.vichubro.online   → Target Group (port 80)   → PHP ECS tasks

HTTP:80 → 301 redirect → HTTPS (enforces SSL)
```

**Health checks** use matcher `200-399` to accommodate 302 redirects from Devise authentication.

### 5.3 RDS MySQL

A single shared RDS MySQL 8.0 instance serves both applications with separate databases:
- `movie_review_production` — Rails app
- `food_ordering_production` — Laravel app

RDS sits in private subnets and only accepts connections from the ECS security group — it is never publicly accessible.

### 5.4 ACM & Route 53

ACM certificates use **DNS validation** — Terraform creates the validation CNAME records in Route 53 automatically, so no manual steps are needed.

Route 53 A records use **ALB alias records** rather than CNAME to the ALB DNS name:
- Alias records are free (no DNS query charge).
- They resolve directly to ALB IPs, enabling health-check-based routing.

### 5.5 CloudWatch & Monitoring

**Log Groups:**
- `/ecs/vishnu-terraform-ror-task` — Puma logs, Rails logs, migration output
- `/ecs/vishnu-terraform-php-task` — Apache access/error logs, PHP output

**Alarms configured:**
- ECS CPU > 80% for both services → SNS → email
- ALB 5XX count > 10 per minute → SNS → email

**Dashboard** — four widgets showing ECS CPU (RoR), ECS CPU (PHP), ALB request count, ALB 5XX errors.

---

## Architecture Overview

```
Internet
    │
    ▼
Route 53
(movie.vichubro.online / food.vichubro.online)
    │
    ▼
ACM (SSL/TLS)
    │
    ▼
Application Load Balancer
 ├── HTTP:80 → 301 redirect → HTTPS
 └── HTTPS:443
      ├── movie.vichubro.online → TG:3000 → RoR ECS (EC2)
      └── food.vichubro.online  → TG:80   → PHP ECS (EC2)
                                                │
                                         Private Subnets
                                                │
                                       Shared RDS MySQL
                                 (movie_review / food_ordering DBs)

GitHub (terraform-migration)
    │ webhook
    ▼
CodePipeline
    ├── Source  → S3 artifact
    ├── Build   → CodeBuild → docker build → ECR push
    └── Deploy  → ECS rolling update

CloudWatch → SNS → Email alerts
```

---

## Lessons Learned & Common Errors

| Error | Cause | Fix |
|---|---|---|
| `CannotPullImageManifest` | ECR repo empty — no image pushed yet | Push an initial image before deploying the service |
| `tmp/pids/server.pid: No such file or directory` | Puma requires `tmp/pids/` directory | Add `RUN mkdir -p tmp/pids` to Dockerfile |
| `FailServiceProvider not found` | `composer install --no-scripts` skipped package discovery | Remove `--no-scripts`, add `composer dump-autoload` |
| `Role Customer not found` | Database seeder not run on startup | Add `php artisan db:seed` to container CMD |
| `ACCOUNT_ID` empty in buildspec | Wrong variable name | Use `AWS_ACCOUNT_ID` (injected by CodeBuild) |
| CodePipeline Deploy: insufficient permissions | Missing ECS/PassRole in CodePipeline IAM role | Add `ecs:UpdateService`, `ecs:RegisterTaskDefinition`, `iam:PassRole` |
| `ERR_OSSL_EVP_UNSUPPORTED` | Webpack 4 incompatible with Node 20 OpenSSL | Add `NODE_OPTIONS=--openssl-legacy-provider` |
| CloudWatch dashboard 400 error | Missing `region` and `annotations` fields in widget properties | Add `region` and `annotations: { horizontal: [] }` to each widget |
