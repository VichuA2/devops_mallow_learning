
# AWS Production Deployment: Manual & Terraform Guide

A comprehensive reference covering the full DevOps lifecycle for two production applications deployed using two approaches — manual AWS Console setup and Terraform Infrastructure as Code (IaC).

| Application | Approach | URL |
|---|---|---|
| Ruby on Rails — Movie Review System | Manual | [ror.vichubro.online](https://ror.vichubro.online) |
| Ruby on Rails — Movie Review System | Terraform | [movies.vichubro.online](https://movies.vichubro.online) |
| Laravel PHP — Food Ordering System | Manual | [php.vichubro.online](https://php.vichubro.online) |
| Laravel PHP — Food Ordering System | Terraform | [food.vichubro.online](https://food.vichubro.online) |

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [VPC & Networking](#2-vpc--networking)
3. [Security Groups & NACLs](#3-security-groups--nacls)
4. [EC2 & Bastion Host](#4-ec2--bastion-host)
5. [Docker & Containerization](#5-docker--containerization)
6. [Amazon ECR](#6-amazon-ecr)
7. [Amazon ECS — EC2 Launch Type](#7-amazon-ecs--ec2-launch-type)
8. [Application Load Balancer](#8-application-load-balancer)
9. [Amazon RDS MySQL](#9-amazon-rds-mysql)
10. [Auto Scaling](#10-auto-scaling)
11. [CI/CD — CodeBuild & CodePipeline](#11-cicd--codebuild--codepipeline)
12. [CloudWatch & Monitoring](#12-cloudwatch--monitoring)
13. [ACM & Route 53](#13-acm--route-53)
14. [IAM Roles & Permissions](#14-iam-roles--permissions)
15. [Terraform Infrastructure as Code](#15-terraform-infrastructure-as-code)
16. [Manual vs Terraform Comparison](#16-manual-vs-terraform-comparison)
17. [Troubleshooting & Lessons Learned](#17-troubleshooting--lessons-learned)
18. [Architecture Diagrams](#18-architecture-diagrams)
19. [Monthly Cost Estimate](#19-monthly-cost-estimate)
20. [Quick Reference](#20-quick-reference)

---

## 1. Project Overview

### Applications Deployed

#### Ruby on Rails — Movie Review System
- **Framework:** Rails 6.1.5
- **Ruby version:** 3.0.4
- **Database:** MySQL (Amazon RDS)
- **Web server:** Puma
- **Features:** User authentication (Devise), movie listings, reviews

#### Laravel PHP — Food Ordering System
- **Framework:** Laravel 11
- **PHP version:** 8.3
- **Database:** MySQL (Amazon RDS)
- **Web server:** Apache
- **Features:** Role-based access (Spatie), hotel/product management, orders, cart

### Two Deployment Approaches

**Manual (Console-based)** — all AWS resources created through the AWS Management Console. Naming convention: `vishnu-manual-*`

**Terraform (IaC)** — all AWS resources defined as code in `.tf` files and provisioned via CLI. Naming convention: `vishnu_terraform_*`

Both deployments run in **ap-south-1 (Mumbai)** and share the same GitHub repositories on different branches:
- `main` → Manual deployment
- `terraform-migration` → Terraform deployment

---

## 2. VPC & Networking

### Manual VPC

**CIDR:** `10.20.0.0/16`

```
vishnu-manual-shared-vpc
  ├── Public Subnet   — 10.20.1.0/24  (ap-south-1a) — Bastion, ALB
  ├── Public Subnet   — 10.20.2.0/24  (ap-south-1b) — ALB
  ├── Private Subnet  — 10.20.3.0/24  (ap-south-1a) — ECS EC2, RDS
  └── Private Subnet  — 10.20.4.0/24  (ap-south-1b) — RDS (Multi-AZ standby)
```

### Terraform VPC

**CIDR:** `10.30.0.0/16`

```
vishnu_terraform_vpc_ror
  ├── Public Subnet 1  — 10.30.1.0/24  (ap-south-1a) — Bastion, ALB, NAT GW
  ├── Public Subnet 2  — 10.30.2.0/24  (ap-south-1b) — ALB, NAT GW
  ├── Private Subnet 1 — 10.30.3.0/24  (ap-south-1a) — ECS tasks, RDS
  └── Private Subnet 2 — 10.30.4.0/24  (ap-south-1b) — ECS tasks, RDS
```

### Key Networking Components

#### Internet Gateway (IGW)
Attached to the VPC. Enables public subnets to send and receive traffic from the internet. Without an IGW, no resource in the VPC can reach the internet.

#### NAT Gateway
Placed in a public subnet. Allows resources in **private subnets** (ECS tasks, RDS) to initiate outbound internet connections — for example, pulling Docker images from ECR, downloading packages — without being directly reachable from the internet.

One NAT GW per AZ prevents cross-AZ data transfer charges and provides high availability. If one AZ goes down, the other AZ's private resources still have outbound internet access through their own NAT GW.

#### Route Tables
- **Public route table:** `0.0.0.0/0 → IGW` — all outbound traffic goes to the internet.
- **Private route table:** `0.0.0.0/0 → NAT GW` — outbound traffic goes through NAT, not directly to internet.

Each subnet is associated with exactly one route table.

#### Why Separate Public and Private Subnets?
- **Public subnets** — resources that need to be reachable from the internet (ALB, Bastion).
- **Private subnets** — resources that should never be directly reachable from the internet (ECS tasks, RDS). Even if a security group was misconfigured, private subnet resources have no public IP and no direct route to the internet.

---

## 3. Security Groups & NACLs

### Security Groups

Stateful firewalls that operate at the **resource level** (EC2 instance, RDS, ALB). Return traffic is automatically allowed — only inbound rules need to be defined for incoming connections.

#### Manual Security Groups

| Security Group | Inbound Rules | Purpose |
|---|---|---|
| `vishnu-manual-shared-bastion-sg` | SSH 22 from 0.0.0.0/0 | Bastion host SSH access |
| `vishnu-manual-shared-alb-sg` | HTTP 80, HTTPS 443 from 0.0.0.0/0 | ALB internet traffic |
| `vishnu-manual-shared-ecs-sg` | Port 32768-65535 from ALB SG; SSH from Bastion SG | ECS EC2 dynamic ports |
| `vishnu-manual-shared-rds-sg` | MySQL 3306 from ECS SG; MySQL 3306 from Bastion SG | RDS — only ECS and bastion |

#### Terraform Security Groups

| Security Group | Inbound Rules | Purpose |
|---|---|---|
| `vishnu_terraform_sg_bastion_ror` | SSH 22 from 0.0.0.0/0 | Bastion host |
| `vishnu_terraform_sg_alb_ror` | HTTP 80, HTTPS 443 from 0.0.0.0/0 | ALB internet traffic |
| `vishnu_terraform_sg_ecs_ror` | Port 32768-65535 from ALB SG; Port 3000, 80 from ALB SG; SSH from Bastion SG | ECS EC2 instances |
| `vishnu_terraform_sg_rds_ror` | MySQL 3306 from ECS SG; MySQL 3306 from Bastion SG | RDS |

### NACLs (Network Access Control Lists)

Stateless firewalls at the **subnet level**. Both inbound AND outbound rules must be configured explicitly. Return traffic is not automatically allowed.

| | Security Groups | NACLs |
|---|---|---|
| State | Stateful — return traffic automatic | Stateless — both directions must be defined |
| Level | Instance / ENI | Subnet |
| Rules | Allow only | Allow and Deny |
| Evaluation | All rules evaluated | Rules evaluated in order by rule number |
| Use case | Primary access control | Additional subnet-level guardrails |

**Public NACL** — allows HTTP (80), HTTPS (443), SSH (22) inbound, and ephemeral ports (1024–65535) for return traffic.

**Private NACL** — allows all traffic from within the VPC CIDR inbound, plus ephemeral return traffic from NAT GW outbound responses.

---

## 4. EC2 & Bastion Host

### Bastion Host

A **bastion host** (also called a jump server) is a hardened EC2 instance in a public subnet used as the sole entry point for SSH access into the private network.

**Why a bastion?**
- ECS EC2 instances and RDS are in private subnets with no public IPs.
- Direct SSH to private instances is impossible from the internet.
- The bastion bridges the gap — you SSH into the bastion, then SSH forward into private instances.

**SSH agent forwarding pattern:**
```bash
# Step 1: Add key to SSH agent locally
ssh-add ~/Downloads/key.pem

# Step 2: SSH to bastion with agent forwarding
ssh -A ec2-user@<bastion-public-ip>

# Step 3: From bastion, SSH to private EC2
ssh ec2-user@<private-ec2-ip>
```

The `-A` flag forwards your local SSH agent to the bastion, so you don't need to copy the key to the bastion itself.

### Manual Bastion
- **Instance:** `vishnu-manual-shared-bastion` (t3.micro)
- **Public IP:** 13.201.53.104
- **Key pair:** `vishnu-manual-shared-keypair`

### Terraform Bastion
- **Instance:** `vishnu_terraform_bastion_ror` (t3.micro)
- **Public IP:** 3.7.129.210
- **Key pair:** `vishnu-terraform-key`

### ECS EC2 Instances

In the EC2 launch type, ECS runs containers on EC2 instances. These instances:
- Run in private subnets (no public IP).
- Use the ECS-optimised Amazon Linux 2 AMI (pre-installed with Docker and the ECS agent).
- Register themselves to the ECS cluster automatically via `user_data`.
- Are managed by an Auto Scaling Group.

**Manual ECS instances:** `vishnu-manual-shared-ecs-instance` (t3.small × 2)

**Terraform ECS instances:** `vishnu-terraform-ecs-ec2-ror` (t3.small × 2, managed by ASG)

---

## 5. Docker & Containerization

### What is Docker?

Docker is an open-source platform that packages applications and their dependencies into lightweight, portable units called **containers**. Unlike virtual machines, containers share the host OS kernel — making them faster to start and significantly more resource-efficient.

### Docker Image
- A **read-only template** used to create containers.
- Built in **layers** — each Dockerfile instruction adds a new layer on top of the previous one.
- Layers are cached — rebuilding only re-runs instructions that changed, making subsequent builds fast.
- Stored in registries such as Amazon ECR or Docker Hub.

### Docker Container
- A **running instance** of an image.
- Isolated from the host and from other containers using Linux namespaces and cgroups.
- **Ephemeral by default** — any data written inside is lost when the container stops.

### Dockerfile Instructions

| Instruction | Purpose |
|---|---|
| `FROM` | Sets the base image |
| `RUN` | Executes a shell command during build |
| `COPY` | Copies files from host into the image |
| `WORKDIR` | Sets the working directory for subsequent instructions |
| `ENV` | Sets environment variables at build and runtime |
| `EXPOSE` | Documents which port the container listens on (documentation only) |
| `ENTRYPOINT` | Fixed executable that always runs when the container starts |
| `CMD` | Default arguments passed to ENTRYPOINT; easily overridden |

**Best practice:** Place frequently changing instructions (like `COPY . .`) near the bottom and stable instructions (like `apt-get install`) near the top to maximise layer cache reuse.

### ENTRYPOINT vs CMD

Both define what runs when a container starts, but serve different roles:

| | ENTRYPOINT | CMD |
|---|---|---|
| Purpose | Fixed executable — always runs | Default arguments — easily overridden |
| Override at runtime | Only with `--entrypoint` flag | Any argument passed at `docker run` |
| Signal handling | Exec form receives SIGTERM correctly | — |

**Exec form vs Shell form:**
- **Exec form** `["executable", "arg"]` — runs the process directly; receives Unix signals. **Preferred.**
- **Shell form** `executable arg` — runs via `/bin/sh -c`; does not forward signals, causing graceful shutdown issues.

**Pattern used in this project:** ENTRYPOINT runs a startup script (database migrations), then `exec "$@"` replaces the shell with the CMD process — ensuring correct signal handling for graceful shutdown.

### Ruby on Rails Dockerfile

```dockerfile
FROM ruby:3.0.4

RUN apt-get update -qq && apt-get install -y \
    build-essential nodejs npm \
    default-libmysqlclient-dev curl git

WORKDIR /app

# Gems cached separately — code changes don't re-install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY package.json ./
RUN npm install --legacy-peer-deps

COPY . .

# Puma requires this directory to write its PID file
RUN mkdir -p tmp/pids tmp/cache tmp/sockets log

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3000
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
```

**entrypoint.sh:**
```bash
#!/bin/bash
set -e
echo "==> Running database migrations..."
bundle exec rails db:migrate 2>/dev/null || bundle exec rails db:create db:migrate
echo "==> Starting Puma..."
exec "$@"
```

### Laravel / PHP Dockerfile

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

### .dockerignore

Always exclude large directories from the Docker build context:
```
node_modules
.git
log
tmp
```

Without `.dockerignore`, Docker copies `node_modules` (often 500MB+) into the build context on every build — making builds slow even when nothing changed.

### Key Dockerfile Decisions

| Decision | Reason |
|---|---|
| `COPY Gemfile ./` then `RUN bundle install` before `COPY . .` | Gems cached as a separate layer — code changes don't re-install all gems |
| `RUN mkdir -p tmp/pids` | Puma requires this directory for its PID file — container crashes without it |
| `composer dump-autoload` after `composer install` | Regenerates autoloader so Spatie service providers are discovered |
| `db:seed` in CMD | Ensures the `Customer` role exists in the database on every container start |
| `food-app/` subdirectory | Laravel app lives in a subdirectory of the repo — Dockerfile placed at repo root |

---

## 6. Amazon ECR

Amazon Elastic Container Registry — AWS's managed private Docker image registry. Integrated with IAM — no separate credentials needed for ECS to pull images.

### Manual ECR Repositories

| Repository | Application |
|---|---|
| `vishnu-manual/movie-ror` | Ruby on Rails (manual deployment) |
| `vishnu-manual/food-php` | Laravel PHP (manual deployment) |

### Terraform ECR Repositories

| Repository | Application |
|---|---|
| `vishnu-terraform/movie-ror` | Ruby on Rails (Terraform deployment) |
| `vishnu-terraform/food-php` | Laravel PHP (Terraform deployment) |

### ECR Lifecycle Policies

Automatically clean up old images to control storage costs:
- Keep last 10 tagged images (prefixed `v`)
- Expire untagged images older than 7 days

### Push Commands

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

## 7. Amazon ECS — EC2 Launch Type

### ECS Concepts

| Concept | Description |
|---|---|
| **Cluster** | Logical grouping of compute resources for running tasks |
| **Task Definition** | Versioned JSON blueprint — container image, CPU, memory, ports, env vars, logging |
| **Task** | One running instance of a task definition |
| **Service** | Maintains desired task count; handles rolling deployments and restarts |
| **Capacity Provider** | Links the cluster to an EC2 Auto Scaling Group |

### EC2 vs Fargate

| | EC2 Launch Type (used here) | Fargate |
|---|---|---|
| Infrastructure | You manage EC2 instances | AWS manages compute |
| Network mode | `bridge` (dynamic ports) | `awsvpc` only |
| Cost model | Pay for EC2 instances (running 24/7) | Pay per task vCPU/memory second |
| SSH access | Yes — can SSH into instances | No server access |
| Startup time | Fast (instances pre-running) | Slightly slower (cold start) |
| Use case | Learning full stack, cost-predictable workloads | Production serverless containers |

**This project uses EC2** to understand the full stack — capacity providers, launch templates, ASG integration, and dynamic port mapping.

### Bridge Network Mode & Dynamic Port Mapping

In EC2 bridge mode, containers use **dynamic host ports**:
- Container always listens on a fixed internal port (e.g., 3000 for Puma, 80 for Apache).
- The EC2 host assigns a random external port from the ephemeral range (32768–65535).
- The ALB discovers the dynamic port automatically via ECS service registration.

```
Container: always port 3000
EC2 host:  random port e.g. 49152 → mapped to container 3000
ALB:       routes to the dynamic host port discovered via ECS
```

This is why the ECS security group must allow the full port range 32768–65535 from the ALB — not just port 3000.

### Manual ECS Setup

**Cluster:** `vishnu-manual-shared-ecs-cluster`

ECS agent installed manually on EC2 instances:
```bash
# Install ecs-init
sudo yum install -y ecs-init

# Configure cluster name
echo ECS_CLUSTER=vishnu-manual-shared-ecs-cluster >> /etc/ecs/ecs.config

# Start ECS agent
sudo systemctl start ecs
```

**Task Definitions:**
- `vishnu-manual-ror-task` — Rails app (bridge mode, port 3000)
- `vishnu-manual-php-task` — Laravel app (bridge mode, port 80)

**Services:**
- `vishnu-manual-ror-service`
- `vishnu-manual-php-service`

### Terraform ECS Setup

**Cluster:** `vishnu-terraform-shared-ecs-cluster-ror`

Instead of manually configuring each instance, Terraform uses a **Launch Template** with `user_data`:

```bash
#!/bin/bash
echo ECS_CLUSTER=vishnu-terraform-shared-ecs-cluster-ror >> /etc/ecs/ecs.config
echo ECS_ENABLE_CONTAINER_METADATA=true >> /etc/ecs/ecs.config
```

Every new EC2 instance launched by the ASG automatically registers to the cluster on boot.

**Capacity Provider** links the cluster to the ASG with managed scaling at 80% target utilisation.

**Task Definitions:**
- `vishnu-terraform-ror-task` — Rails app (bridge mode, port 3000)
- `vishnu-terraform-php-task` — Laravel app (bridge mode, port 80)

**Services:**
- `vishnu-terraform-ror-service`
- `vishnu-terraform-php-service`

### Deployment Circuit Breaker

Prevents failed deployments from cycling indefinitely:
- If new tasks keep crashing during a deployment, ECS automatically rolls back to the previous working task definition revision.
- Without this, ECS would retry failed tasks indefinitely until manually stopped.

```hcl
deployment_circuit_breaker {
  enable   = true
  rollback = true
}
```

### CloudWatch Logging from ECS

All containers send logs to CloudWatch using the `awslogs` log driver:

```json
"logConfiguration": {
  "logDriver": "awslogs",
  "options": {
    "awslogs-group": "/ecs/vishnu-terraform-ror-task",
    "awslogs-region": "ap-south-1",
    "awslogs-stream-prefix": "ecs"
  }
}
```

This replaces the need to SSH into containers to read logs — all output is centralised in CloudWatch.

---

## 8. Application Load Balancer

### Manual ALB

**Name:** `vishnu-manual-shared-alb`

**Routing:**
```
HTTP:80   → 301 redirect → HTTPS
HTTPS:443
  ├── ror2.vichubro.online / ror.vichubro.online → TG (port 3000) → RoR tasks
  └── php.vichubro.online                        → TG (port 80)   → PHP tasks
```

### Terraform ALB

**Name:** `vishnu-terraform-alb-ror`

**Routing:**
```
HTTP:80   → 301 redirect → HTTPS
HTTPS:443
  ├── movies.vichubro.online → TG (port 3000) → RoR tasks
  └── food.vichubro.online   → TG (port 80)   → PHP tasks
```

### Host-Based Routing

A single ALB serves both applications. The ALB inspects the `Host` header of each request and forwards to the correct target group:

```hcl
condition {
  host_header {
    values = ["food.vichubro.online"]
  }
}
```

### Target Groups

Each application has its own target group:
- **RoR target group:** IP type, port 3000, health check path `/`
- **PHP target group:** IP type, port 80, health check path `/`

**Health check matcher `200-399`** — accommodates 302 redirects from Devise authentication. Without this, the ALB would mark healthy tasks as unhealthy because login redirects return 302.

### HTTP to HTTPS Redirect

```
Browser → http://movies.vichubro.online
ALB → 301 Moved Permanently → https://movies.vichubro.online
Browser → https://movies.vichubro.online (secure)
```

This enforces HTTPS on all traffic without requiring any application-level changes.

---

## 9. Amazon RDS MySQL

A single shared RDS MySQL 8.0 instance serves both applications with separate databases.

### Manual RDS

| Setting | Value |
|---|---|
| Identifier | `vishnu-manual-shared-rds` |
| Engine | MySQL 8.0 |
| Instance | db.t3.micro |
| Database (RoR) | `movie_review_production` |
| Database (PHP) | `food_ordering_production` |
| Subnet | Private subnets only |
| Public access | No |

**Endpoint:** `vishnu-manual-shared-rds.ctci4sqw4n7q.ap-south-1.rds.amazonaws.com:3306`

### Terraform RDS

| Setting | Value |
|---|---|
| Identifier | `vishnu-terraform-rds-shared` |
| Engine | MySQL 8.0 |
| Instance | db.t3.micro |
| Storage | 20 GB gp3 (auto-scales to 100 GB) |
| Encryption | Enabled |
| Backup retention | 7 days |

**Endpoint:** `vishnu-terraform-rds-shared.c5400ykkskvs.ap-south-1.rds.amazonaws.com:3306`

### Security

RDS only accepts connections from the ECS security group and the Bastion security group — it is never publicly accessible. Even if someone gained access to the VPC, they would need to be in an allowed security group to connect to MySQL on port 3306.

### Database Migrations

Migrations run automatically on container startup via the entrypoint script or CMD:

**Rails:** `bundle exec rails db:migrate`
**Laravel:** `php artisan migrate --force`

The `--force` flag is required in production as Laravel prompts for confirmation otherwise.

---

## 10. Auto Scaling

### Two Types of Scaling

**EC2 ASG Scaling** — scales the number of EC2 instances in the ECS cluster. Managed by the ECS Capacity Provider at 80% target capacity utilisation. Min: 1, Max: 3 instances.

**ECS App Auto Scaling** — scales the number of running tasks per ECS service. Independent of EC2 instance count.

### Manual Auto Scaling

Configured via AWS Console:
- CloudWatch CPU alarm → Scale out ECS tasks when CPU > 70%
- Cooldown periods prevent rapid fluctuation

### Terraform Auto Scaling

Two policies per service — CPU and Memory target tracking:

```hcl
target_tracking_scaling_policy_configuration {
  target_value       = 70.0   # keep average CPU at 70%
  scale_out_cooldown = 60     # add tasks quickly when busy
  scale_in_cooldown  = 300    # wait 5 min before removing tasks

  predefined_metric_specification {
    predefined_metric_type = "ECSServiceAverageCPUUtilization"
  }
}
```

**Target Tracking** — AWS automatically adds or removes tasks to maintain the metric at the target value, similar to a thermostat maintaining a set temperature.

**Scale out quickly, scale in slowly** — the asymmetric cooldowns prevent removing capacity during a traffic spike while still cleaning up idle tasks promptly.

---

## 11. CI/CD — CodeBuild & CodePipeline

### Pipeline Architecture

```
Developer pushes to GitHub
          │
          ▼ (webhook triggers immediately)
    CodePipeline
          │
    ┌─────┴──────┐
    │   Source   │ → Pulls code from GitHub → S3 artifact
    └─────┬──────┘
          │
    ┌─────┴──────┐
    │   Build    │ → CodeBuild
    │            │     ├── docker build
    │            │     ├── docker push → ECR
    │            │     └── imagedefinitions.json → S3
    └─────┬──────┘
          │
    ┌─────┴──────┐
    │   Deploy   │ → ECS rolling update (new task definition revision)
    └────────────┘
```

### Manual CI/CD Resources

| Resource | Name |
|---|---|
| CodeBuild (RoR) | `vishnu-manual-ror-codebuild` |
| CodeBuild (PHP) | `vishnu-manual-php-codebuild` |
| CodePipeline (RoR) | `vishnu-manual-ror-pipeline` |
| CodePipeline (PHP) | `vishnu-manual-php-pipeline` |
| Source branch | `main` |

### Terraform CI/CD Resources

| Resource | Name |
|---|---|
| CodeBuild (RoR) | `vishnu-terraform-ror-codebuild` |
| CodeBuild (PHP) | `vishnu-terraform-php-codebuild` |
| CodePipeline (RoR) | `vishnu-terraform-ror-pipeline` |
| CodePipeline (PHP) | `vishnu-terraform-php-pipeline` |
| Source branch | `terraform-migration` |

### buildspec.yml

The `buildspec.yml` at the repo root instructs CodeBuild:

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

**Environment variables injected by CodeBuild/Terraform:**

| Variable | Value | Common Mistake |
|---|---|---|
| `AWS_ACCOUNT_ID` | AWS account number | Using `ACCOUNT_ID` instead — will be empty |
| `AWS_DEFAULT_REGION` | `ap-south-1` | Auto-injected by CodeBuild |
| `IMAGE_REPO_NAME` | ECR repo name | Must match the ECR repo exactly |
| `ECS_CONTAINER_NAME` | Container name in task definition | Must match task def container name exactly |

**imagedefinitions.json** — the artifact passed from Build to Deploy stage. Tells CodePipeline which container image to update in ECS:
```json
[{"name": "movie-ror-container", "imageUri": "782208973532.dkr.ecr.ap-south-1.amazonaws.com/vishnu-terraform/movie-ror:abc1234"}]
```

### GitHub Integration

**CodeStar Connections** is unavailable in `ap-south-1` (Mumbai). **GitHub OAuth v1** is used instead:

```hcl
configuration = {
  Owner                = "VichuA2"
  Repo                 = "movie-review-system"
  Branch               = "terraform-migration"
  OAuthToken           = var.github_oauth_token
  PollForSourceChanges = false   # webhook is faster and cheaper than polling
}
```

A webhook is registered with GitHub so every push triggers the pipeline immediately.

### Pipeline Execution Mode: Queued

Every commit gets its own pipeline run, executed in order. No deployments are skipped or race with each other — important for maintaining correct deployment order in production.

| Mode | Behaviour | Best For |
|---|---|---|
| **Superseded** | New run cancels current one | Active development — only latest matters |
| **Queued** | One at a time in order ✅ | Production — every commit must deploy |
| **Parallel** | All runs simultaneously | Not recommended for deployments |

### IAM Permissions Required for CodePipeline

| Stage | Permissions |
|---|---|
| Source | S3 read/write on artifact bucket |
| Build | `codebuild:StartBuild`, `codebuild:BatchGetBuilds`, S3 read/write |
| Deploy | `ecs:UpdateService`, `ecs:RegisterTaskDefinition`, `ecs:DescribeServices`, `iam:PassRole` |

Missing `iam:PassRole` or ECS permissions causes the Deploy stage to fail with "The provided role does not have sufficient permissions to access ECS."

---

## 12. CloudWatch & Monitoring

### Log Groups

#### Manual
| Log Group | Contents |
|---|---|
| `/ecs/vishnu-manual-ror-task` | Puma server logs, Rails application logs |
| `/ecs/vishnu-manual-php-task` | Apache access/error logs, Laravel logs |

#### Terraform
| Log Group | Contents |
|---|---|
| `/ecs/vishnu-terraform-ror-task` | Puma server logs, Rails logs, migration output |
| `/ecs/vishnu-terraform-php-task` | Apache access/error logs, PHP/Laravel output |

Logs are retained for 30 days. CloudWatch logging removes the need to SSH into containers for debugging — all container output is centralised and searchable.

### CloudWatch Alarms

#### Terraform Alarms

| Alarm | Metric | Threshold | Action |
|---|---|---|---|
| `vishnu-terraform-cpu-high-ror` | ECS CPU utilisation | > 80% for 2 evaluation periods | SNS → Email |
| `vishnu-terraform-cpu-high-php` | ECS CPU utilisation | > 80% for 2 evaluation periods | SNS → Email |
| `vishnu-terraform-alb-5xx-ror` | ALB HTTP 5XX count | > 10 per minute | SNS → Email |

### CloudWatch Dashboard

Four widgets on the `vishnu-terraform-dashboard-ror` dashboard:
1. RoR ECS CPU Utilization (time series)
2. PHP ECS CPU Utilization (time series)
3. ALB Request Count (sum)
4. ALB 5XX Errors (sum)

**Common dashboard error:** Widget JSON must include `region`, `stat`, `stacked`, and `annotations` fields — missing any of these causes a 400 InvalidParameterInput error from AWS.

### SNS — Simple Notification Service

`vishnu-terraform-alerts-ror` topic with email subscription. When any alarm triggers, an email is sent immediately to the configured address.

---

## 13. ACM & Route 53

### SSL Certificates (ACM)

ACM (AWS Certificate Manager) provides free SSL/TLS certificates for AWS resources.

**Validation method: DNS** — Terraform creates validation CNAME records in Route 53 automatically. No manual steps required. The certificate is issued once AWS confirms ownership of the domain via the CNAME records.

#### Manual Certificates
- `ror.vichubro.online`
- `php.vichubro.online`

#### Terraform Certificates
- `movies.vichubro.online`
- `food.vichubro.online`

Both certificates attached to their respective ALB HTTPS listeners.

### Route 53 DNS Records

#### Manual Records
| Record | Type | Points to |
|---|---|---|
| `ror.vichubro.online` | A (alias) | Manual ALB |
| `php.vichubro.online` | A (alias) | Manual ALB |

#### Terraform Records
| Record | Type | Points to |
|---|---|---|
| `movies.vichubro.online` | A (alias) | Terraform ALB |
| `food.vichubro.online` | A (alias) | Terraform ALB |

**Alias records vs CNAME:**
- Alias records are **free** — no DNS query charge per lookup.
- Alias records can be used at the **zone apex** (root domain).
- Alias records support **health-check-based routing**.
- CNAME records cannot be used at the zone apex and incur per-query charges.

---

## 14. IAM Roles & Permissions

IAM (Identity and Access Management) roles grant AWS services permission to interact with other AWS services. No passwords — roles use temporary credentials automatically rotated by AWS.

### Manual IAM Roles

| Role | Used By | Key Permissions |
|---|---|---|
| `vishnu-manual-ecs-task-exec-role` | ECS task execution | Pull from ECR, write CloudWatch logs |
| `vishnu-manual-ecs-task-role` | Running containers | S3, CloudWatch |
| `vishnu-manual-ec2-ecs-role` | EC2 instances | Register to ECS cluster |
| `vishnu-manual-codebuild-role` | CodeBuild | ECR push/pull, S3, CloudWatch |
| `vishnu-manual-codepipeline-role` | CodePipeline | S3, CodeBuild, ECS, PassRole |

### Terraform IAM Roles

| Role | Used By | Key Permissions |
|---|---|---|
| `vishnu_terraform_ecs_task_exec_role_ror` | ECS task execution | ECR pull, CloudWatch logs, SSM parameters |
| `vishnu_terraform_ecs_task_role_ror` | Running containers | S3 read/write, CloudWatch logs |
| `vishnu_terraform_ec2_ecs_role_ror` | EC2 instances in ASG | ECS registration, SSM agent |
| `vishnu_terraform_codebuild_role_ror` | CodeBuild | ECR push/pull, S3, CloudWatch |
| `vishnu_terraform_codepipeline_role_ror` | CodePipeline | S3, CodeBuild, ECS UpdateService, PassRole |

**Principle of least privilege** — each role only has the permissions it needs for its specific job. The ECS task execution role can pull images and write logs, but cannot modify EC2 instances. The CodePipeline role can update ECS services, but cannot create new EC2 instances.

---

## 15. Terraform Infrastructure as Code

### What is Terraform?

Terraform is an open-source IaC tool by HashiCorp. Infrastructure is defined in declarative `.tf` configuration files — you describe the **desired state**, and Terraform figures out what to create, modify, or destroy to reach it.

**IaC benefits over manual Console setup:**
- **Reproducible** — same code produces identical infrastructure every time.
- **Version controlled** — infrastructure changes tracked in Git like application code.
- **Auditable** — every change is a code commit with a message and author.
- **Destroyable** — `terraform destroy` removes everything cleanly; no forgotten resources.
- **Reusable** — parameterise with variables to deploy to dev, staging, and production.

### Core Concepts

**Provider** — plugin connecting Terraform to a cloud API:
```hcl
provider "aws" {
  region = "ap-south-1"
  default_tags {
    tags = { Project = "vishnu-terraform", ManagedBy = "Terraform" }
  }
}
```

**Resource** — a single piece of infrastructure:
```hcl
resource "aws_vpc" "vishnu_terraform_vpc_ror" {
  cidr_block           = "10.30.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "vishnu_terraform_vpc_ror" }
}
```

**Variable** — parameterises configuration:
```hcl
variable "db_password" {
  type      = string
  sensitive = true   # never shown in plan output or logs
}
```

Sensitive values via environment variables — never hardcoded:
```bash
export TF_VAR_db_password="MySecurePassword123!"
export TF_VAR_github_oauth_token="ghp_xxxx"
export TF_VAR_ror_secret_key_base="$(openssl rand -hex 64)"
```

**Data source** — reads existing resources without managing them:
```hcl
data "aws_route53_zone" "zone" {
  name = "vichubro.online"
}
```

**Output** — exposes values after apply:
```hcl
output "alb_dns_name" {
  value = aws_lb.vishnu_terraform_alb_ror.dns_name
}
```

**State** — stored remotely in S3 for team collaboration:
```hcl
backend "s3" {
  bucket  = "my-terraform-state-vichu"
  key     = "vishnu-terraform/terraform.tfstate"
  region  = "ap-south-1"
  encrypt = true
}
```

### Terraform Workflow

```
terraform init     → Download providers, initialise S3 backend
terraform plan     → Preview all changes (read-only, no real changes)
terraform apply    → Execute the plan and provision resources
terraform destroy  → Remove all managed resources
```

Always run `terraform plan` before `apply` — it shows a diff of exactly what will be created, changed, or destroyed.

### Naming Convention

```
vishnu_terraform_<resource_type>_ror
```

Examples: `vishnu_terraform_vpc_ror`, `vishnu_terraform_sg_alb_ror`, `vishnu_terraform_ecs_cluster_ror`

Consistent naming makes it easy to identify Terraform-managed resources in the Console and prevents confusion with manually created `vishnu-manual-*` resources.

### Terraform File Structure

| File | What it provisions |
|---|---|
| `main.tf` | Provider config, S3 backend |
| `variables.tf` | All input variables with defaults |
| `outputs.tf` | Key resource values post-apply |
| `vpc.tf` | VPC, subnets, IGW, NAT GWs, route tables, NACLs |
| `security_groups.tf` | SGs for ALB, ECS, RDS, Bastion |
| `ec2.tf` | Bastion host with Elastic IP |
| `rds.tf` | RDS MySQL, subnet group, parameter group |
| `ecr.tf` | ECR repos with lifecycle policies |
| `iam.tf` | All IAM roles and policies |
| `alb.tf` | ALB, listeners, target groups, routing rules |
| `acm.tf` | ACM certificate, DNS validation, Route 53 records |
| `ecs.tf` | Cluster, launch template, ASG, task definitions, services |
| `asg.tf` | App Auto Scaling policies, CloudWatch CPU alarms |
| `cloudwatch.tf` | Log groups, SNS, dashboard, ALB alarm |
| `s3.tf` | Pipeline artifact bucket |
| `codebuild.tf` | CodeBuild projects |
| `codepipeline.tf` | Pipelines + GitHub webhooks |

---

## 16. Manual vs Terraform Comparison

| Aspect | Manual | Terraform |
|---|---|---|
| Resource creation | AWS Console — point and click | `.tf` files — code |
| Reproducibility | Must redo every step manually | `terraform apply` recreates everything |
| Version control | Not tracked | All changes committed to Git |
| Time to deploy | Hours (first time) | Minutes (after initial write) |
| Error risk | High — easy to miss a step | Low — code is deterministic |
| Visibility | Must check each service in Console | `terraform state list` shows everything |
| Cleanup | Must manually delete each resource | `terraform destroy` removes all |
| Naming | `vishnu-manual-*` | `vishnu_terraform_*` |
| VPC CIDR | `10.20.0.0/16` | `10.30.0.0/16` |
| RoR URL | `ror.vichubro.online` | `movies.vichubro.online` |
| PHP URL | `php.vichubro.online` | `food.vichubro.online` |
| ECS cluster | `vishnu-manual-shared-ecs-cluster` | `vishnu-terraform-shared-ecs-cluster-ror` |
| EC2 registration | Manual `ecs-init` setup | Automatic via `user_data` in launch template |
| GitHub branch | `main` | `terraform-migration` |

---

## 17. Troubleshooting & Lessons Learned

| Error | Root Cause | Fix Applied |
|---|---|---|
| `CannotPullImageManifest` | ECR repository empty — no image pushed yet | Push initial Docker image before deploying ECS service |
| ECS tasks failing — exit code 1 | Container crashed on startup | Check CloudWatch logs for the actual error |
| `tmp/pids/server.pid: No such file or directory` | Puma requires `tmp/pids/` to write its PID file | Add `RUN mkdir -p tmp/pids` to Rails Dockerfile |
| `FailServiceProvider not found` (Laravel) | `composer install --no-scripts` skipped service provider discovery | Remove `--no-scripts`, add `composer dump-autoload --optimize` |
| `Role Customer not found` | Database seeder not run on container startup | Add `php artisan db:seed --class=RolePermissionSeeder --force` to CMD |
| `$ACCOUNT_ID` empty in buildspec | Wrong environment variable name — CodeBuild injects `AWS_ACCOUNT_ID` | Use `$AWS_ACCOUNT_ID` not `$ACCOUNT_ID` |
| `ECS_CONTAINER_NAME` mismatch | Container name in buildspec didn't match task definition | Must be identical: `movie-ror-container` in both |
| CodePipeline Deploy: insufficient permissions | Missing ECS and PassRole permissions in CodePipeline IAM policy | Add `ecs:UpdateService`, `ecs:RegisterTaskDefinition`, `iam:PassRole` |
| `ERR_OSSL_EVP_UNSUPPORTED` (webpack) | Webpack 4 incompatible with Node 20 OpenSSL | Add `NODE_OPTIONS=--openssl-legacy-provider` to precompile step |
| CloudWatch dashboard 400 error | Missing `region` and `annotations` fields in widget JSON | Add `region` and `annotations: { horizontal: [] }` to every widget |
| ALB health check failing (502) | Dynamic port range blocked between ALB SG and ECS SG | Open ports 32768–65535 from ALB SG to ECS SG |
| Route 53 pointing to wrong ALB | Old manual record existed before Terraform | Run `terraform apply -target=aws_route53_record` to force update |
| ASG not scaling down | `protect_from_scale_in = true` preventing instance termination | Remove protection on target instance then terminate via ASG |
| 503 after ECS inactivity | ALB target group had no healthy targets | Force new ECS deployment to restart tasks |
| `BucketAlreadyExists` for Terraform state | S3 bucket names are globally unique | Choose a unique bucket name |
| CodeStar Connections unavailable | `ap-south-1` (Mumbai) doesn't support CodeStar Connections | Use GitHub OAuth v1 provider instead |

---

## 18. Architecture Diagrams

### Manual Architecture

```
Internet
    │
    ▼
Route 53
  ror.vichubro.online  ──┐
  php.vichubro.online  ──┤
                         ▼
                   ACM (SSL/TLS)
                         │
                         ▼
             vishnu-manual-shared-alb
             (ap-south-1, public subnets)
                         │
           ┌─────────────┴─────────────┐
      HTTP:80 → 301              HTTPS:443
                              Host-based routing
                          ror.*          php.*
                            │              │
                      TG port 3000    TG port 80
                            │              │
              Private Subnets — ECS EC2 Instances
              vishnu-manual-shared-ecs-cluster
              ┌──────────────────────────────┐
              │  movie-ror-container  :3000  │
              │  food-php-container   :80    │
              └──────────────┬───────────────┘
                             │
                 vishnu-manual-shared-rds
                 MySQL 8.0 (private subnet)
                 movie_review_production
                 food_ordering_production

GitHub (main branch)
    │
    ▼
CodePipeline → CodeBuild → ECR → ECS Deploy
vishnu-manual-ror-pipeline
vishnu-manual-php-pipeline

CloudWatch Logs + Alarms → SNS → Email
```

### Terraform Architecture

```
Internet
    │
    ▼
Route 53
  movies.vichubro.online ──┐
  food.vichubro.online   ──┤
                           ▼
                     ACM (SSL/TLS)
                           │
                           ▼
               vishnu-terraform-alb-ror
               (ap-south-1, public subnets)
                           │
             ┌─────────────┴─────────────┐
        HTTP:80 → 301              HTTPS:443
                                Host-based routing
                            movies.*        food.*
                               │               │
                         TG port 3000     TG port 80
                               │               │
            Private Subnets — ECS EC2 ASG Instances
            vishnu-terraform-shared-ecs-cluster-ror
            vishnu-terraform-ecs-asg-ror (min:1, max:3)
            ┌────────────────────────────────────────┐
            │  movie-ror-container  :3000  (bridge)  │
            │  food-php-container   :80    (bridge)  │
            └────────────────┬───────────────────────┘
                             │
                vishnu-terraform-rds-shared
                MySQL 8.0 (private subnet)
                movie_review_production
                food_ordering_production

GitHub (terraform-migration branch)
    │ webhook
    ▼
CodePipeline → CodeBuild → ECR → ECS Deploy
vishnu-terraform-ror-pipeline
vishnu-terraform-php-pipeline

CloudWatch Logs + Alarms → SNS → Email
Auto Scaling: CPU > 70% → add tasks | < 70% → remove tasks
```

---

## 19. Monthly Cost Estimate

### Manual Infrastructure

| Service | Configuration | Estimate |
|---|---|---|
| EC2 (ECS) | 2 × t3.small, 24/7 | ~$30/month |
| EC2 (Bastion) | 1 × t3.micro, 24/7 | ~$8/month |
| RDS MySQL | db.t3.micro, single-AZ | ~$15/month |
| ALB | 1 load balancer | ~$16/month |
| NAT Gateway | 1 × NAT GW | ~$32/month |
| ECR | ~2 GB storage | ~$0.20/month |
| CodeBuild | ~500 build minutes | ~$2.50/month |
| CodePipeline | 2 pipelines | ~$2/month |
| CloudWatch | Logs + alarms | ~$2/month |
| **Manual Total** | | **~$108/month** |

### Terraform Infrastructure

| Service | Configuration | Estimate |
|---|---|---|
| EC2 (ECS ASG) | 2 × t3.small, 24/7 | ~$30/month |
| EC2 (Bastion) | 1 × t3.micro, 24/7 | ~$8/month |
| RDS MySQL | db.t3.micro, single-AZ | ~$15/month |
| ALB | 1 load balancer | ~$16/month |
| NAT Gateway | 2 × NAT GW (one per AZ) | ~$65/month |
| ECR | ~2 GB storage | ~$0.20/month |
| CodeBuild | ~500 build minutes | ~$2.50/month |
| CodePipeline | 2 pipelines | ~$2/month |
| CloudWatch | Logs + dashboard + alarms | ~$3/month |
| S3 | Artifact bucket | ~$0.50/month |
| **Terraform Total** | | **~$142/month** |

> **Combined total: ~$250/month** for running both deployments simultaneously.
> NAT Gateway dominates cost. Single NAT GW (sacrificing cross-AZ HA) would save ~$32/month on the Terraform side.

---

## 20. Quick Reference

| Term | Definition |
|---|---|
| VPC | Isolated virtual network in AWS |
| Subnet | Subdivision of a VPC within one Availability Zone |
| IGW | Internet Gateway — allows public subnets to reach the internet |
| NAT Gateway | Allows private resources to reach the internet outbound only |
| Security Group | Stateful instance-level firewall — allow rules only |
| NACL | Stateless subnet-level firewall — allow and deny rules |
| Bastion Host | Jump server in public subnet for SSH into private resources |
| Docker Image | Read-only template for creating containers |
| Docker Container | Running instance of an image |
| Dockerfile | Build instructions for a Docker image |
| ENTRYPOINT | Fixed executable — always runs when container starts |
| CMD | Default arguments — easily overridden at `docker run` |
| ECR | AWS private Docker image registry |
| ECS Cluster | Logical group of compute for running containers |
| Task Definition | Versioned blueprint for a container (image, CPU, memory, ports) |
| ECS Service | Keeps desired task count running; handles rolling deployments |
| Bridge Mode | EC2 network mode with dynamic host port mapping |
| Capacity Provider | Links ECS cluster to an EC2 Auto Scaling Group |
| Target Tracking | Auto-scaling policy maintaining a metric at a set target value |
| Circuit Breaker | Auto-rollback on failed ECS deployment |
| ALB | Application Load Balancer — Layer 7, routes by host/path |
| Target Group | Group of ECS tasks registered behind an ALB listener |
| Host-based Routing | ALB routes to different target groups based on the `Host` header |
| ACM | AWS Certificate Manager — free SSL/TLS certificates |
| Route 53 | AWS DNS service |
| Alias Record | Free Route 53 record type that points directly to AWS resources |
| CodeBuild | Managed build service — runs `buildspec.yml` |
| CodePipeline | CI/CD orchestration — Source → Build → Deploy |
| buildspec.yml | Instructions file for CodeBuild |
| imagedefinitions.json | Artifact telling CodePipeline which container image to deploy to ECS |
| Terraform | IaC tool — defines infrastructure as `.tf` files |
| terraform plan | Previews changes without making them |
| terraform apply | Provisions resources defined in `.tf` files |
| State file | Terraform's record of managed resources (`terraform.tfstate`) |
| Remote state | State stored in S3 for team collaboration |
| RDS | Relational Database Service — managed MySQL/PostgreSQL |
| SNS | Simple Notification Service — sends alerts via email/SMS |
| CloudWatch | AWS monitoring — logs, metrics, alarms, dashboards |
| IAM Role | AWS identity granting services permissions to interact with other services |
| PassRole | IAM permission allowing a service to pass a role to another service |
EOF
Output

exit code 0
