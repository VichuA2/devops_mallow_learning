
# Introduction to PHP Application Hosting

PHP is a server-side scripting language widely used for developing dynamic web applications.

PHP applications are commonly hosted using:

* Apache
* Nginx
* PHP-FPM
* MySQL/MariaDB

In production environments, PHP applications are deployed behind:

* Load Balancers
* Auto Scaling Groups
* DNS services

to ensure:

* High availability
* Scalability
* Better performance

---

# Basic PHP Hosting Architecture

```text id="m7x2vp"
User
 ↓
DNS
 ↓
Load Balancer
 ↓
EC2 Instance
 ↓
Apache / Nginx
 ↓
PHP Application
```

---

# Why PHP Hosting Requires Load Balancer

Without Load Balancer:

```text id="r5v9tk"
Users
  ↓
Single EC2 Instance
  ↓
Server Overload / Failure
```

Problems:

* Downtime
* Single point of failure
* Poor scalability

---

# With Load Balancer and Auto Scaling

```text id="x8k3pr"
Users
  ↓
Application Load Balancer
  ↓
Auto Scaling Group
 ├── EC2 Instance 1
 ├── EC2 Instance 2
 └── EC2 Instance 3
```

Benefits:

* Traffic distribution
* Automatic scaling
* High availability
* Fault tolerance

---

# PHP Application Hosting Components

Main AWS services used:

| Service         | Purpose              |
| --------------- | -------------------- |
| EC2             | Host PHP application |
| VPC             | Networking           |
| Security Groups | Firewall             |
| ALB             | Traffic distribution |
| Route53         | DNS                  |
| ACM             | HTTPS certificate    |
| Auto Scaling    | Automatic scaling    |
| CloudWatch      | Monitoring           |

---

# Web Servers for PHP

PHP applications are commonly hosted using:

| Web Server | Usage                    |
| ---------- | ------------------------ |
| Apache     | Traditional PHP hosting  |
| Nginx      | High-performance hosting |

---

# PHP Hosting Workflow

```text id="q6v1mr"
Browser Request
      ↓
Load Balancer
      ↓
Web Server
      ↓
PHP Processing
      ↓
Database Query
      ↓
Response Returned
```

---

# Apache with PHP

Apache processes PHP requests using:

* mod_php
* PHP-FPM

---

# Nginx with PHP

Nginx forwards PHP requests to:

* PHP-FPM

---

# Basic PHP Application Structure

```text id="z4m8tx"
php-app/
│
├── index.php
├── config.php
├── css/
├── js/
└── images/
```

---

# Example PHP Application

```php id="p9v3kr"
<?php
echo "PHP Application Hosted Successfully";
?>
```

---

# Hosting PHP Application on EC2

---

# Step 1 – Launch EC2 Instance

Create EC2 instance with:

* Amazon Linux / Ubuntu
* Public subnet
* Security Group

---

# Step 2 – Install Apache

## Amazon Linux

```bash id="u7k4xp"
sudo yum update -y
```

```bash id="r2m9vn"
sudo yum install httpd -y
```

---

# Start Apache

```bash id="y5x3pk"
sudo systemctl start httpd
```

```bash id="q8v1tm"
sudo systemctl enable httpd
```

---

# Step 3 – Install PHP

```bash id="w4m7zr"
sudo yum install php php-mysqlnd -y
```

---

# Verify PHP Installation

```bash id="n3k8pt"
php -v
```

---

# Step 4 – Deploy PHP Application

Move application files:

```bash id="k6v2rm"
sudo cp -r php-app/* /var/www/html/
```

---

# Step 5 – Restart Apache

```bash id="m2x9vp"
sudo systemctl restart httpd
```

---

# Test Application

Open browser:

```text id="h7p4kr"
http://public-ip
```

---

# Security Group Configuration

Allow:

| Port | Purpose |
| ---- | ------- |
| 22   | SSH     |
| 80   | HTTP    |
| 443  | HTTPS   |

---

# Load Balancer Integration

Application Load Balancer distributes requests across EC2 instances.

---

# ALB Workflow

```text id="v8m3tp"
Users
  ↓
Application Load Balancer
  ↓
Target Group
  ↓
EC2 PHP Servers
```

---

# Target Groups

Target Groups contain:

* EC2 instances hosting PHP application

---

# Health Checks

ALB continuously checks:

* Application health
* HTTP response

---

# Example Health Check

| Setting  | Example |
| -------- | ------- |
| Protocol | HTTP    |
| Path     | /       |
| Port     | 80      |

---

# HTTPS with ACM

HTTPS secures PHP applications.

---

# ACM Certificate Workflow

```text id="t4x8pr"
User
 ↓
HTTPS Request
 ↓
Load Balancer
 ↓
ACM Certificate Validation
 ↓
PHP Application
```

---

# Route53 DNS Integration

Route53 maps domain names to the Load Balancer.

---

# DNS Flow

```text id="y7k2vm"
Domain
 ↓
Route53
 ↓
Application Load Balancer
 ↓
EC2 PHP Servers
```

---

# Auto Scaling for PHP Application

Auto Scaling automatically adjusts EC2 instances based on traffic and CPU utilization.

---

# Why Auto Scaling is Required

Benefits:

* High availability
* Better performance
* Automatic recovery
* Cost optimization

---

# Auto Scaling Workflow

```text id="p5m1zr"
High CPU Usage
       ↓
CloudWatch Alarm
       ↓
Scaling Policy Triggered
       ↓
New EC2 Instance Created
```

---

# Launch Template for PHP Hosting

Launch Templates define reusable EC2 configuration.

---

# Launch Template Includes

* AMI
* Instance type
* Security Groups
* User Data
* IAM Role

---

# Example User Data Script

```bash id="f3v7kn"
#!/bin/bash
yum update -y
yum install httpd php -y
systemctl start httpd
systemctl enable httpd
```

---

# Auto Scaling Policy

Target:

* CPU Utilization > 20%

---

# Target Tracking Policy

```text id="w8k4xp"
Maintain Average CPU Utilization = 20%
```

---

# CloudWatch Monitoring

CloudWatch monitors:

* CPU usage
* Network traffic
* Scaling events

---

# Terraform for PHP Hosting

Terraform automates:

* VPC
* EC2
* ALB
* ASG
* Route53
* ACM

---

# AWS Provider

```hcl id="q2m8vt"
provider "aws" {
  region = "us-east-1"
}
```

---

# Create Security Group

```hcl id="u5x9pr"
resource "aws_security_group" "php_sg" {
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

```hcl id="r4k2mx"
resource "aws_launch_template" "php_template" {
  name_prefix   = "php-template"
  image_id      = "ami-123456"
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.php_sg.id
  ]

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install httpd php -y
systemctl start httpd
systemctl enable httpd
EOF
  )
}
```

---

# Create Target Group

```hcl id="m7v3pt"
resource "aws_lb_target_group" "php_tg" {
  name     = "php-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}
```

---

# Create Application Load Balancer

```hcl id="x3p8kr"
resource "aws_lb" "php_alb" {
  name               = "php-alb"
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.php_sg.id
  ]

  subnets = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]
}
```

---

# Create Listener

```hcl id="k5m1vn"
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.php_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.php_tg.arn
  }
}
```

---

# Create Auto Scaling Group

```hcl id="t8v4xp"
resource "aws_autoscaling_group" "php_asg" {
  desired_capacity = 2
  min_size         = 1
  max_size         = 4

  vpc_zone_identifier = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]

  target_group_arns = [
    aws_lb_target_group.php_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.php_template.id
    version = "$Latest"
  }
}
```

---

# Create Scaling Policy

```hcl id="n6x2pr"
resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.php_asg.name
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

# Terraform Workflow

```text id="j9k3tm"
Write Terraform Code
        ↓
terraform init
        ↓
terraform plan
        ↓
terraform apply
        ↓
PHP Hosting Infrastructure Created
```

---

# Cost Estimation

| Resource        | Cost |
| --------------- | ---- |
| EC2 Instances   | Paid |
| ALB             | Paid |
| NAT Gateway     | Paid |
| Route53         | Paid |
| ACM Certificate | Free |
| CloudWatch      | Paid |

---

# Important AWS Console Options

| Service | Important Options         |
| ------- | ------------------------- |
| EC2     | Launch Templates          |
| ALB     | Listeners & Target Groups |
| ASG     | Scaling Policies          |
| ACM     | SSL Certificates          |
| Route53 | DNS Records               |

---
