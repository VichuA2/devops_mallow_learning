
# Introduction to Ruby on Rails (RoR)

Ruby on Rails (RoR) is a full-stack web application framework written in Ruby.

RoR is used to build:

* Web applications
* APIs
* SaaS platforms
* Enterprise applications

Rails follows:

* MVC Architecture (Model View Controller)

---

# Why Host RoR Applications on AWS

AWS provides:

* Scalability
* High availability
* Managed databases
* Monitoring
* Load balancing
* Auto Scaling

for production-grade Rails applications.

---

# Basic RoR Hosting Architecture

```text id="m7x2vp"
User
 ↓
DNS
 ↓
Load Balancer
 ↓
Nginx Web Server
 ↓
Puma Application Server
 ↓
Ruby on Rails Application
 ↓
RDS Database
```

---

# Components Used in RoR Hosting

| Component  | Purpose                  |
| ---------- | ------------------------ |
| EC2        | Host Rails application   |
| RDS        | Database                 |
| Nginx      | Reverse proxy            |
| Puma       | Rails application server |
| ALB        | Load balancing           |
| Route53    | DNS                      |
| ACM        | HTTPS                    |
| ASG        | Auto Scaling             |
| CloudWatch | Monitoring               |

---

# RoR Application Hosting Workflow

```text id="x8m4pr"
Browser Request
      ↓
Load Balancer
      ↓
Nginx
      ↓
Puma
      ↓
Rails Application
      ↓
RDS Database
```

---

# What is Puma?

Puma is the application server used to run Rails applications.

---

# Puma Responsibilities

* Process Rails requests
* Handle concurrent users
* Connect Rails application with web server

---

# Why Puma is Used

Benefits:

* Multithreading
* Better performance
* Production-ready

---

# What is Nginx?

Nginx acts as:

* Reverse proxy
* Web server
* Static file server

---

# Nginx Workflow

```text id="r5v9tm"
Client Request
      ↓
Nginx
      ↓
Puma Server
      ↓
Rails Application
```

---

# Why Nginx is Required

* Handles static files
* SSL termination
* Reverse proxy
* Load balancing
* Better request handling

---

# Rails MVC Architecture

```text id="u4k8xp"
Model
  ↓
Controller
  ↓
View
```

---

# Database Used for RoR

Rails applications commonly use:

* MySQL
* PostgreSQL

through:

* Amazon RDS

---

# Production Architecture

```text id="t8m3vr"
Users
  ↓
Route53 DNS
  ↓
Application Load Balancer
  ↓
Auto Scaling Group
  ↓
EC2 Rails Servers
  ↓
Amazon RDS
```

---

# Hosting Rails Application on EC2

---

# Step 1 – Launch EC2 Instance

Launch EC2 with:

* Amazon Linux / Ubuntu
* Public subnet
* Security Group

---

# Step 2 – Install Dependencies

## Update Packages

```bash id="p9x4kt"
sudo yum update -y
```

---

# Install Git

```bash id="q2m8vr"
sudo yum install git -y
```

---

# Install Required Packages

```bash id="k6v1tm"
sudo yum install gcc gcc-c++ make openssl-devel zlib-devel readline-devel libyaml-devel libffi-devel -y
```

---

# Step 3 – Install Ruby Using rbenv

---

# Install rbenv

```bash id="w4k7xp"
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
```

---

# Install ruby-build

```bash id="n3v8pr"
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
```

---

# Configure rbenv

```bash id="m7k2xt"
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
```

```bash id="x5v9tp"
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
```

```bash id="r8m4pk"
source ~/.bashrc
```

---

# Install Ruby

```bash id="f2x7vn"
rbenv install 3.0.4
```

```bash id="u9k3tr"
rbenv global 3.0.4
```

---

# Verify Ruby

```bash id="p4m8xr"
ruby -v
```

---

# Step 4 – Install Rails

```bash id="y5v2kn"
gem install rails -v 6.1.5
```

---

# Verify Rails

```bash id="h8m1tp"
rails -v
```

---

# Step 5 – Install Node.js and Yarn

Rails requires JavaScript runtime.

---

# Install Node.js

```bash id="t7v4pr"
curl -fsSL https://rpm.nodesource.com/setup_16.x | sudo bash -
```

```bash id="k3m9xt"
sudo yum install -y nodejs
```

---

# Install Yarn

```bash id="n6v2pk"
sudo npm install -g yarn
```

---

# Step 6 – Clone Rails Application

```bash id="w8k4mr"
git clone <repository-url>
```

---

# Move into Project Directory

```bash id="x2m7tp"
cd ror-project
```

---

# Step 7 – Install Gems

```bash id="f5v9xr"
bundle install
```

---

# Step 8 – Configure Database

Edit:

```text id="u3k8pm"
config/database.yml
```

---

# Example Database Configuration

```yaml id="q7m1tv"
production:
  adapter: mysql2
  encoding: utf8
  database: rorapp
  username: admin
  password: password123
  host: rds-endpoint.amazonaws.com
```

---

# Step 9 – Create and Migrate Database

```bash id="v4k2pr"
bundle exec rails db:create
```

```bash id="m8x7tn"
bundle exec rails db:migrate
```

---

# Step 10 – Install Puma

```bash id="r5m1xp"
bundle add puma
```

---

# Start Puma Server

```bash id="z2v8tr"
bundle exec puma -b tcp://0.0.0.0:3000
```

---

# Step 11 – Install Nginx

```bash id="k7m4vp"
sudo amazon-linux-extras install nginx1 -y
```

---

# Start Nginx

```bash id="n4x8pk"
sudo systemctl start nginx
```

```bash id="y1m3tr"
sudo systemctl enable nginx
```

---

# Nginx Reverse Proxy Configuration

Edit:

```text id="t8k5xp"
/etc/nginx/nginx.conf
```

---

# Example Nginx Config

```nginx id="f3v9mr"
server {
    listen 80;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

---

# Verify Nginx Configuration

```bash id="x6m2tp"
sudo nginx -t
```

---

# Restart Nginx

```bash id="u8v4pr"
sudo systemctl restart nginx
```

---

# Step 12 – Configure Systemd Service

Create service file:

```text id="q4m7xr"
/etc/systemd/system/rorapp.service
```

---

# Example Service File

```ini id="p7v1tk"
[Unit]
Description=Rails Application

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/ror-project
ExecStart=/home/ec2-user/.rbenv/shims/bundle exec puma -C config/puma.rb

[Install]
WantedBy=multi-user.target
```

---

# Reload Systemd

```bash id="m5k9xp"
sudo systemctl daemon-reload
```

---

# Enable Service

```bash id="r2v8tm"
sudo systemctl enable rorapp
```

---

# Start Service

```bash id="w6m4pr"
sudo systemctl start rorapp
```

---

# Verify Status

```bash id="x3k1tv"
sudo systemctl status rorapp
```

---

# HTTPS with ACM and ALB

Production applications use:

* HTTPS
* SSL certificates
* Application Load Balancer

---

# HTTPS Flow

```text id="v9m2xp"
User
 ↓
HTTPS Request
 ↓
ALB
 ↓
ACM Certificate Validation
 ↓
Rails Servers
```

---

# Route53 DNS Integration

Route53 maps:

* Domain name → ALB

---

# DNS Flow

```text id="u7k5tr"
Domain
 ↓
Route53
 ↓
Application Load Balancer
 ↓
Rails Servers
```

---

# Auto Scaling for RoR Application

Auto Scaling ensures:

* Availability
* Performance
* Traffic handling

---

# ASG Workflow

```text id="k2m8vp"
CPU Utilization > 20%
          ↓
CloudWatch Alarm
          ↓
Auto Scaling Triggered
          ↓
New EC2 Instance Created
```

---

# Launch Template for RoR

Launch Template includes:

* AMI
* Security Groups
* User Data
* Instance Type

---

# Example User Data

```bash id="q8v3pm"
#!/bin/bash
yum install nginx -y
systemctl start nginx
```

---

# CloudWatch Monitoring

CloudWatch monitors:

* CPU utilization
* Logs
* Scaling events

---

# SNS Alerts

SNS sends:

* Email notifications
* Alarm alerts

---

# Terraform for RoR Hosting

Terraform automates:

* VPC
* EC2
* ALB
* RDS
* ASG
* CloudWatch
* SNS

---

# AWS Provider

```hcl id="m4x7tr"
provider "aws" {
  region = "us-east-1"
}
```

---

# Create Security Group

```hcl id="z8k2vp"
resource "aws_security_group" "ror_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

---

# Create Launch Template

```hcl id="p5m1xr"
resource "aws_launch_template" "ror_template" {
  name_prefix   = "ror-template"
  image_id      = "ami-123456"
  instance_type = "t2.micro"
}
```

---

# Create Target Group

```hcl id="x7v4tp"
resource "aws_lb_target_group" "ror_tg" {
  name     = "ror-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}
```

---

# Create Application Load Balancer

```hcl id="n6m2pk"
resource "aws_lb" "ror_alb" {
  name               = "ror-alb"
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.ror_sg.id
  ]

  subnets = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]
}
```

---

# Create Auto Scaling Group

```hcl id="r9v5tm"
resource "aws_autoscaling_group" "ror_asg" {
  desired_capacity = 2
  min_size         = 1
  max_size         = 4

  vpc_zone_identifier = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]

  target_group_arns = [
    aws_lb_target_group.ror_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.ror_template.id
    version = "$Latest"
  }
}
```

---

# Create Scaling Policy

```hcl id="u3k8xp"
resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.ror_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 20.0
  }
}
```

---

# Create CloudWatch Alarm

```hcl id="t7m1vr"
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "high-cpu"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 20
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
}
```

---

# Terraform Workflow

```text id="f2v8kp"
Write Terraform Code
        ↓
terraform init
        ↓
terraform plan
        ↓
terraform apply
        ↓
RoR Infrastructure Created
```

---

# Important AWS Console Options

| Service    | Important Options         |
| ---------- | ------------------------- |
| EC2        | Launch Templates          |
| ALB        | Listeners & Target Groups |
| ASG        | Scaling Policies          |
| RDS        | DB Configuration          |
| CloudWatch | Alarms & Metrics          |
| Route53    | DNS                       |

---

