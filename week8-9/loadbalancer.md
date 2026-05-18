
# Introduction to Load Balancer

A Load Balancer distributes incoming traffic across multiple servers or instances.

AWS provides:

* Elastic Load Balancer (ELB)

to improve:

* Availability
* Scalability
* Reliability
* Fault tolerance

---

# Why Load Balancer is Required

Without a Load Balancer:

```text id="m4v8pt"
User Traffic
     ↓
Single Server
     ↓
Server Overload / Failure
```

Problems:

* Single point of failure
* Performance bottlenecks
* No high availability

---

# With Load Balancer

```text id="r7k2xp"
Users
  ↓
Load Balancer
 ├── EC2 Instance 1
 ├── EC2 Instance 2
 └── EC2 Instance 3
```

Benefits:

* Traffic distribution
* High availability
* Auto Scaling support
* Better performance

---

# What is ELB?

ELB stands for:

* Elastic Load Balancer

AWS ELB automatically distributes traffic across multiple targets.

---

# ELB Features

* High availability
* Automatic scaling
* SSL/TLS termination
* Health monitoring
* Traffic routing
* Fault tolerance

---

# Types of Load Balancers in AWS

AWS provides multiple load balancer types.

---

# 1. Application Load Balancer (ALB)

ALB works at:

* Layer 7 (Application Layer)

---

# ALB Features

* HTTP/HTTPS routing
* Path-based routing
* Host-based routing
* WebSocket support
* SSL termination

---

# ALB Use Cases

* Web applications
* APIs
* Microservices
* Container applications

---

# ALB Traffic Flow

```text id="x8m3vr"
User
 ↓
Application Load Balancer
 ↓
EC2 / Containers
```

---

# 2. Network Load Balancer (NLB)

NLB works at:

* Layer 4 (Transport Layer)

---

# NLB Features

* Very high performance
* Low latency
* TCP/UDP support
* Static IP support

---

# NLB Use Cases

* Gaming applications
* Real-time applications
* High-performance workloads

---

# 3. Gateway Load Balancer (GWLB)

Used for:

* Network appliances
* Firewalls
* Security inspection

---

# 4. Classic Load Balancer (CLB)

Legacy load balancer.

Supports:

* Basic Layer 4 and Layer 7 traffic

---

# ELB Type Comparison

| Load Balancer | Layer     | Use Case             |
| ------------- | --------- | -------------------- |
| ALB           | Layer 7   | Web applications     |
| NLB           | Layer 4   | High-performance TCP |
| GWLB          | Layer 3/4 | Security appliances  |
| CLB           | Legacy    | Older applications   |

---

# Target Groups

Target Groups define where the Load Balancer forwards traffic.

---

# Target Group Components

* EC2 instances
* IP addresses
* Lambda functions

---

# Target Group Workflow

```text id="v2m7kp"
Load Balancer
      ↓
Target Group
      ↓
EC2 Instances
```

---

# Target Group Features

* Health checks
* Port mapping
* Routing configuration
* Load balancing targets

---

# Target Types

| Target Type | Description      |
| ----------- | ---------------- |
| Instance    | EC2 instances    |
| IP          | IP addresses     |
| Lambda      | Lambda functions |

---

# Listeners

Listeners check incoming traffic on specific ports and protocols.

---

# Listener Example

| Protocol | Port |
| -------- | ---- |
| HTTP     | 80   |
| HTTPS    | 443  |

---

# Listener Workflow

```text id="k3v8pr"
Client Request
      ↓
Listener
      ↓
Target Group
      ↓
EC2 Instances
```

---

# HTTP Listener

Handles:

* Non-secure traffic

### Port

```text id="u5x2kn"
80
```

---

# HTTPS Listener

Handles:

* Encrypted secure traffic

### Port

```text id="m8r4tp"
443
```

---

# SSL/TLS with ELB

HTTPS listeners use:

* ACM Certificates

for secure communication.

---

# ACM Integration Flow

```text id="y4m9vx"
User
 ↓
HTTPS Request
 ↓
Load Balancer
 ↓
ACM Certificate Validation
 ↓
Target Group
```

---

# Health Checks

Health checks monitor target availability.

---

# Health Check Purpose

* Detect unhealthy instances
* Route traffic only to healthy targets

---

# Health Check Example

| Setting  | Example |
| -------- | ------- |
| Path     | /health |
| Protocol | HTTP    |
| Port     | 80      |

---

# Health Check Workflow

```text id="n6k2pt"
Load Balancer
      ↓
Health Check Request
      ↓
Healthy / Unhealthy Decision
```

---

# Sticky Sessions

Sticky sessions ensure a user continues communicating with the same backend server.

---

# Why Sticky Sessions are Used

* Session persistence
* User login continuity

---

# Sticky Session Workflow

```text id="q7v1mr"
User
 ↓
Load Balancer
 ↓
Same Backend Instance
```

---

# Deregistration Delay

Deregistration delay controls how long existing connections remain active before instance removal.

---

# Example

During Auto Scaling:

* Existing requests complete before termination

---

# Benefits

* Prevents request interruption
* Smooth scaling operations

---

# Cross-Zone Load Balancing

Distributes traffic evenly across Availability Zones.

---

# Benefits

* Better availability
* Balanced traffic distribution

---

# Internet-Facing vs Internal Load Balancer

| Type            | Purpose               |
| --------------- | --------------------- |
| Internet-facing | Public traffic        |
| Internal        | Internal applications |

---

# Load Balancer Security

Load Balancers use:

* Security Groups
* SSL/TLS
* WAF
* ACM

---

# Security Group Example

Allow:

* HTTP (80)
* HTTPS (443)

---

# Load Balancer Ports

| Port | Purpose |
| ---- | ------- |
| 80   | HTTP    |
| 443  | HTTPS   |

---

# Traffic Flow Example

```text id="x5m8tr"
Internet
   ↓
ALB Listener
   ↓
Target Group
   ↓
EC2 Instances
```

---

# Create Load Balancer Using AWS Console

---

# Steps

1. Open EC2 Console
2. Select Load Balancers
3. Create Load Balancer
4. Choose ALB/NLB
5. Configure listeners
6. Configure security groups
7. Create target group
8. Register targets
9. Attach ACM certificate

---

# Important ALB Configuration Options

| Option          | Purpose             |
| --------------- | ------------------- |
| Scheme          | Internet/Internal   |
| IP Address Type | IPv4/IPv6           |
| Listener        | Port handling       |
| Security Groups | Firewall            |
| Health Checks   | Target monitoring   |
| Sticky Sessions | Session persistence |

---

# Terraform for ELB

Terraform automates ELB infrastructure.

---

# Create Security Group

```hcl id="v3x7kp"
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

---

# Create Target Group

```hcl id="n4m8xt"
resource "aws_lb_target_group" "web_tg" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path = "/"
  }
}
```

---

# Create Application Load Balancer

```hcl id="k6p2vr"
resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]
}
```

---

# Create HTTP Listener

```hcl id="m2x7qt"
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
```

---

# Create HTTPS Listener

```hcl id="w5n3pk"
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
```

---

# Register EC2 Instances

```hcl id="f8v4mr"
resource "aws_lb_target_group_attachment" "attach" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.web.id
  port             = 80
}
```

---

# Terraform Workflow

```text id="r2k9xp"
Write Terraform Code
        ↓
terraform init
        ↓
terraform plan
        ↓
terraform apply
        ↓
Load Balancer Created
```

---

# AWS Console ELB Options

Important ELB Console Sections:

| Option          | Purpose         |
| --------------- | --------------- |
| Load Balancers  | Main ELB        |
| Target Groups   | Backend targets |
| Listeners       | Port handling   |
| Health Checks   | Monitoring      |
| Security Groups | Firewall        |
| Certificates    | HTTPS setup     |

---

# Cost Estimation

| Resource        | Cost     |
| --------------- | -------- |
| ALB             | Paid     |
| NLB             | Paid     |
| Data Transfer   | Paid     |
| ACM Certificate | Free     |
| Target Groups   | Included |

---

# Real-Time Production Architecture

```text id="z8m3kp"
Users
  ↓
Route53
  ↓
Application Load Balancer
  ↓
Auto Scaling Group
  ↓
EC2 Instances
```

---
