
# Introduction to Auto Scaling

Auto Scaling automatically adjusts the number of EC2 instances based on application demand and traffic.

AWS Auto Scaling helps:

* Maintain application availability
* Handle traffic spikes
* Reduce manual intervention
* Optimize infrastructure cost

---

# Why Auto Scaling is Required

Without Auto Scaling:

```text id="m4x7kp"
High Traffic
     ↓
Single EC2 Instance
     ↓
Performance Issues / Downtime
```

Problems:

* Server overload
* Downtime
* Poor user experience

---

# With Auto Scaling

```text id="v8k2pr"
Users
  ↓
Load Balancer
  ↓
Auto Scaling Group
 ├── EC2 Instance 1
 ├── EC2 Instance 2
 └── EC2 Instance 3
```

Benefits:

* Automatic scaling
* High availability
* Better performance
* Cost optimization

---

# What is Auto Scaling Group (ASG)?

An Auto Scaling Group manages:

* EC2 instance creation
* Scaling operations
* Health replacement
* Traffic balancing

---

# ASG Responsibilities

* Launch EC2 instances
* Terminate unhealthy instances
* Scale in/out automatically
* Maintain desired capacity

---

# Auto Scaling Workflow

```text id="q3v9mt"
Traffic Increase
      ↓
CloudWatch Alarm
      ↓
Scaling Policy Triggered
      ↓
New EC2 Instances Created
```

---

# Components of ASG

Main components:

* Launch Template
* Auto Scaling Group
* Scaling Policies
* CloudWatch Alarms
* Load Balancer

---

# Launch Template

Launch Templates define EC2 configuration used by ASG.

---

# Launch Template Contains

* AMI
* Instance Type
* Security Groups
* IAM Role
* User Data
* EBS Configuration

---

# ASG Capacity Types

| Capacity         | Meaning                   |
| ---------------- | ------------------------- |
| Desired Capacity | Target instance count     |
| Minimum Capacity | Minimum running instances |
| Maximum Capacity | Maximum allowed instances |

---

# Example

```text id="n7m2xp"
Min = 1
Desired = 2
Max = 5
```

---

# Auto Scaling Policies

Scaling policies define how scaling occurs.

---

# 1. Target Tracking Scaling Policy

Automatically adjusts instances to maintain a target metric value.

---

# Example

Maintain:

* CPU Utilization = 50%

---

# Target Tracking Workflow

```text id="w4k8zr"
CPU Usage > 50%
       ↓
Launch New Instance
```

---

# Benefits

* Easy configuration
* Automatic management
* Most commonly used

---

# 2. Step Scaling Policy

Scaling occurs in steps based on alarm thresholds.

---

# Example

| CPU Usage | Action          |
| --------- | --------------- |
| >50%      | Add 1 instance  |
| >70%      | Add 2 instances |

---

# Step Scaling Workflow

```text id="f8x3vp"
Metric Threshold
      ↓
Step Policy Triggered
      ↓
Scale Out/In
```

---

# 3. Dynamic Scaling

Automatically adjusts resources based on real-time demand.

---

# Dynamic Scaling Features

* Continuous monitoring
* Real-time scaling
* Automatic resource adjustment

---

# 4. Scheduled Scaling

Scaling occurs at scheduled times.

---

# Example Use Cases

* Business hours traffic
* Seasonal workloads

---

# Scheduled Scaling Example

```text id="u5m1tr"
Morning 9 AM
    ↓
Increase Instances
```

---

# 5. Predictive Scaling

Uses machine learning to predict future traffic patterns.

---

# Predictive Scaling Features

* Forecast traffic
* Scale proactively
* Improve performance

---

# Example

Traffic expected during:

* Black Friday
* Product launch

---

# Scaling Policy Comparison

| Policy             | Usage                   |
| ------------------ | ----------------------- |
| Target Tracking    | General workloads       |
| Step Scaling       | Threshold-based control |
| Scheduled Scaling  | Time-based traffic      |
| Predictive Scaling | Forecasted demand       |

---

# Scale Out vs Scale In

| Operation | Meaning          |
| --------- | ---------------- |
| Scale Out | Add instances    |
| Scale In  | Remove instances |

---

# Cool Down Period

Cooldown prevents frequent scaling actions.

---

# Why Cooldown is Important

Without cooldown:

* Continuous scaling may occur

---

# Cooldown Workflow

```text id="k2v8mp"
Scaling Action
      ↓
Cooldown Period
      ↓
Next Scaling Allowed
```

---

# Benefits

* Prevents instability
* Reduces unnecessary scaling

---

# Warm Pool

Warm Pool keeps pre-initialized EC2 instances ready.

---

# Benefits of Warm Pool

* Faster scaling
* Reduced startup time
* Better application response

---

# Warm Pool Workflow

```text id="y6p4tk"
Warm Pool
    ↓
Traffic Spike
    ↓
Ready Instance Activated
```

---

# Scale-In Protection

Protects specific instances from termination during scale-in operations.

---

# Use Cases

* Long-running jobs
* Critical workloads

---

# Health Checks in ASG

ASG continuously monitors instance health.

---

# Health Check Types

| Type             | Purpose                  |
| ---------------- | ------------------------ |
| EC2 Health Check | Instance status          |
| ELB Health Check | Application availability |

---

# Health Check Workflow

```text id="r8m2xn"
Unhealthy Instance
       ↓
ASG Detects Failure
       ↓
Replace Instance
```

---

# ASG and ELB Integration

ASG commonly integrates with:

* Application Load Balancer

---

# Traffic Flow

```text id="t7v1kp"
Users
  ↓
Load Balancer
  ↓
Auto Scaling Group
  ↓
EC2 Instances
```

---

# Important Ports

| Port | Purpose    |
| ---- | ---------- |
| 22   | SSH        |
| 80   | HTTP       |
| 443  | HTTPS      |
| 3306 | MySQL      |
| 5432 | PostgreSQL |

---

# Auto Scaling Metrics

Scaling decisions are based on metrics.

---

# Common Metrics

* CPU Utilization
* Network Traffic
* Request Count
* Memory Usage (custom)

---

# CloudWatch Integration

ASG uses CloudWatch alarms for scaling automation.

---

# CloudWatch Workflow

```text id="m9x5tr"
CloudWatch Alarm
       ↓
Scaling Policy
       ↓
ASG Action
```

---

# Create ASG Using AWS Console

---

# Steps

1. Create Launch Template
2. Create Auto Scaling Group
3. Configure subnets
4. Attach Load Balancer
5. Configure scaling policies
6. Configure health checks
7. Launch ASG

---

# Terraform for ASG

Terraform automates Auto Scaling infrastructure.

---

# Create Launch Template

```hcl id="n3k8vp"
resource "aws_launch_template" "web_template" {
  name_prefix   = "web-template"
  image_id      = "ami-123456"
  instance_type = "t2.micro"

  user_data = base64encode(<<EOF
#!/bin/bash
yum install nginx -y
systemctl start nginx
EOF
  )
}
```

---

# Create Auto Scaling Group

```hcl id="x6v2tm"
resource "aws_autoscaling_group" "web_asg" {
  desired_capacity = 2
  max_size         = 4
  min_size         = 1

  vpc_zone_identifier = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]

  launch_template {
    id      = aws_launch_template.web_template.id
    version = "$Latest"
  }
}
```

---

# Create Target Tracking Policy

```hcl id="j7p4wr"
resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "cpu-target-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}
```

---

# Create CloudWatch Alarm

```hcl id="h2x9km"
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
}
```

---

# ASG Terraform Workflow

```text id="w8m4tp"
Write Terraform Code
        ↓
terraform init
        ↓
terraform plan
        ↓
terraform apply
        ↓
ASG Infrastructure Created
```

---

# AWS Console ASG Options

Important Auto Scaling Console Sections:

| Option              | Purpose                   |
| ------------------- | ------------------------- |
| Launch Templates    | EC2 configuration         |
| Auto Scaling Groups | Scaling management        |
| Scaling Policies    | Scaling rules             |
| Warm Pools          | Pre-initialized instances |
| Lifecycle Hooks     | Scaling actions           |
| Health Checks       | Instance monitoring       |

---

# Cost Estimation

| Resource        | Cost |
| --------------- | ---- |
| EC2 Instances   | Paid |
| Load Balancer   | Paid |
| CloudWatch      | Paid |
| NAT Gateway     | Paid |
| ACM Certificate | Free |

---
