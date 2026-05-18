
# Introduction to EC2

EC2 stands for:

* Elastic Compute Cloud

Amazon EC2 is a virtual server service provided by AWS used to run applications in the cloud.

EC2 allows users to:

* Launch virtual machines
* Run applications
* Configure networking
* Attach storage
* Scale infrastructure

---

# Why EC2 is Important

EC2 provides:

* Scalable computing
* Flexible infrastructure
* On-demand virtual servers
* Cloud-based application hosting

---

# Basic EC2 Architecture

```text id="m7x3pk"
User
 ↓
AWS EC2 Instance
 ↓
Operating System
 ↓
Application
```

---

# EC2 Components

Main EC2 components:

* AMI
* Instance Types
* Key Pairs
* Storage
* Security Groups
* Elastic IP
* IAM Roles

---

# Amazon Machine Image (AMI)

AMI stands for:

* Amazon Machine Image

An AMI is a preconfigured template used to launch EC2 instances.

---

# AMI Contains

* Operating System
* Software packages
* Application configuration
* Storage mappings

---

# Types of AMIs

| Type            | Description        |
| --------------- | ------------------ |
| AWS Managed AMI | Provided by AWS    |
| Custom AMI      | User-created image |
| Marketplace AMI | Third-party images |

---

# Example AMIs

* Amazon Linux
* Ubuntu
* Red Hat
* Windows Server

---

# AMI Workflow

```text id="v2p8km"
AMI
 ↓
Launch EC2 Instance
 ↓
Running Virtual Server
```

---

# EC2 Instance Types

Instance types define:

* CPU
* Memory
* Storage
* Network performance

---

# Instance Type Naming Example

```text id="q8m4tr"
t2.micro
```

---

# Instance Family Categories

| Family   | Purpose            |
| -------- | ------------------ |
| T Series | General purpose    |
| C Series | Compute optimized  |
| R Series | Memory optimized   |
| M Series | Balanced workloads |
| P Series | GPU workloads      |

---

# Common Instance Types

| Instance Type | Usage              |
| ------------- | ------------------ |
| t2.micro      | Free tier/testing  |
| t3.medium     | Small applications |
| c5.large      | Compute-intensive  |
| r5.large      | Memory-intensive   |

---

# EC2 Pricing Models

AWS provides multiple purchase options.

---

# 1. On-Demand Instances

Pay only for usage duration.

### Features

* No long-term commitment
* Flexible
* Higher cost

---

# 2. Reserved Instances

Reserved for 1–3 years.

### Benefits

* Lower pricing
* Predictable workloads

---

# 3. Spot Instances

Unused AWS capacity offered at low cost.

### Limitation

* Can terminate anytime

---

# 4. Savings Plans

Flexible pricing discounts based on long-term usage.

---

# Pricing Model Comparison

| Pricing Model | Cost   | Flexibility |
| ------------- | ------ | ----------- |
| On-Demand     | High   | High        |
| Reserved      | Lower  | Medium      |
| Spot          | Lowest | Low         |

---

# Key Pairs

Key pairs are used for secure SSH access to EC2 instances.

---

# Components of Key Pair

| Component   | Purpose        |
| ----------- | -------------- |
| Public Key  | Stored in AWS  |
| Private Key | Stored by user |

---

# SSH Access Flow

```text id="t5v1zn"
Private Key
    ↓
EC2 Authentication
    ↓
Secure SSH Login
```

---

# Example SSH Command

```bash id="p9x3km"
ssh -i mykey.pem ec2-user@public-ip
```

---

# Launch Templates

Launch Templates define reusable EC2 configuration settings.

---

# Launch Template Contains

* AMI
* Instance type
* Security Groups
* Storage
* IAM role
* User data scripts

---

# Benefits of Launch Templates

* Reusable configuration
* Auto Scaling integration
* Faster deployments
* Consistency

---

# Launch Template Workflow

```text id="r8m2pt"
Launch Template
        ↓
Auto Scaling Group
        ↓
EC2 Instances
```

---

# Storage Services in EC2

AWS provides multiple storage options.

---

# 1. EBS – Elastic Block Store

EBS is block-level storage attached to EC2 instances.

---

# Features of EBS

* Persistent storage
* High durability
* Snapshot support
* Encryption support

---

# EBS Use Cases

* Databases
* Operating systems
* Applications

---

# Types of EBS Volumes

| Type | Purpose              |
| ---- | -------------------- |
| gp3  | General purpose SSD  |
| io2  | High performance     |
| st1  | Throughput optimized |
| sc1  | Cold HDD             |

---

# EBS Workflow

```text id="x3v7kp"
EBS Volume
    ↓
Attach to EC2
    ↓
Persistent Storage
```

---

# 2. EFS – Elastic File System

EFS is a managed shared file storage service.

---

# Features of EFS

* Shared storage
* Multiple EC2 access
* Scalable storage
* Linux file system

---

# EFS Use Cases

* Shared application data
* Container storage
* Web content sharing

---

# EFS Architecture

```text id="n4k9vx"
Multiple EC2 Instances
         ↓
EFS Shared Storage
```

---

# 3. Instance Store

Temporary storage physically attached to the host machine.

---

# Features

* Very high performance
* Temporary data
* Data lost after instance stop/termination

---

# Instance Store Use Cases

* Cache
* Temporary files
* Buffers

---

# EBS vs EFS vs Instance Store

| Feature       | EBS   | EFS            | Instance Store |
| ------------- | ----- | -------------- | -------------- |
| Storage Type  | Block | File           | Local          |
| Persistence   | Yes   | Yes            | No             |
| Shared Access | No    | Yes            | No             |
| Performance   | High  | Shared         | Very High      |
| Use Case      | OS/DB | Shared storage | Temporary data |

---

# Snapshots in AWS

Snapshots are backups of EBS volumes.

---

# EBS Snapshot Features

* Incremental backup
* Stored in S3
* Disaster recovery support

---

# Snapshot Workflow

```text id="j5p8mx"
EBS Volume
    ↓
Snapshot
    ↓
Backup Stored in AWS
```

---

# EC2 Image Snapshot

Custom AMIs can be created from EC2 instances.

### Benefits

* Faster server replication
* Backup and recovery

---

# Create Snapshot Steps

1. Open EC2 Console
2. Select Volume
3. Create Snapshot
4. Add tags
5. Create backup

---

# EBS Encryption

EBS encryption protects data at rest.

---

# Encryption Benefits

* Secure storage
* Compliance
* Data protection

---

# Encryption Types

| Type             | Description       |
| ---------------- | ----------------- |
| AWS Managed Keys | Default           |
| KMS Keys         | Custom encryption |

---

# EBS Encryption Workflow

```text id="k9v2wr"
EBS Volume
     ↓
Encryption
     ↓
Secure Data Storage
```

---

# Elastic IP (EIP)

Elastic IP is a static public IPv4 address.

---

# Why Elastic IP is Used

* Static server access
* Avoid IP changes
* DNS stability

---

# Elastic IP Workflow

```text id="m3r7kp"
Elastic IP
    ↓
Associated with EC2
    ↓
Static Public Access
```

---

# Important Note

Unused Elastic IPs may generate charges.

---

# IAM Instance Profile Role

Instance profiles allow EC2 instances to access AWS services securely.

---

# Why IAM Roles are Important

Avoid storing:

* Access Keys
* Secret Keys

inside EC2 instances.

---

# IAM Role Workflow

```text id="u7x4nv"
EC2 Instance
      ↓
IAM Role
      ↓
Temporary Credentials
      ↓
AWS Service Access
```

---

# Common EC2 Role Use Cases

* Access S3
* CloudWatch logging
* Systems Manager access

---

# Provisioning EC2 Using Terraform

Terraform automates EC2 deployment.

---

# Provider Configuration

```hcl id="f8m3pt"
provider "aws" {
  region = "us-east-1"
}
```

---

# Create Security Group

```hcl id="y2k7vn"
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

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

```hcl id="r4p8xm"
resource "aws_launch_template" "web_template" {
  name_prefix   = "web-template"
  image_id      = "ami-123456"
  instance_type = "t2.micro"

  key_name = "my-key"

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]
}
```

---

# Create EC2 Instance

```hcl id="k6v9tp"
resource "aws_instance" "web" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
}
```

---

# Attach Elastic IP

```hcl id="x8m2qr"
resource "aws_eip" "web_eip" {
  instance = aws_instance.web.id
}
```

---

# Create IAM Role

```hcl id="p3v7wn"
resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
```

---

# Terraform Workflow

```text id="h4k8xp"
Write Terraform Code
        ↓
terraform init
        ↓
terraform plan
        ↓
terraform apply
        ↓
EC2 Infrastructure Created
```

---

# AWS Console Options

Important EC2 Console Options:

| Option           | Purpose          |
| ---------------- | ---------------- |
| Instances        | Virtual servers  |
| AMIs             | Server templates |
| Volumes          | EBS storage      |
| Snapshots        | Backups          |
| Security Groups  | Firewall         |
| Elastic IPs      | Static IPs       |
| Launch Templates | Reusable configs |

---

# Cost Estimation

| Resource     | Cost               |
| ------------ | ------------------ |
| EC2 Instance | Paid               |
| EBS Volume   | Paid               |
| EFS          | Paid               |
| Elastic IP   | Free when attached |
| Snapshots    | Paid               |

---

# Real-Time Production Architecture

```text id="z1v6mt"
Internet
   ↓
Load Balancer
   ↓
EC2 Instances
   ↓
EBS Storage
   ↓
Application
```

---
