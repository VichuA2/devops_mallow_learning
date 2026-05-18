# Week 6 – Terraform Notes

# Introduction to Terraform

Terraform is an Infrastructure as Code (IaC) tool developed by HashiCorp.
It is used to automate the provisioning and management of infrastructure resources such as:

* Virtual Machines
* Networks
* Load Balancers
* Databases
* Storage
* DNS
* Security Groups
* Cloud Services

Terraform allows infrastructure to be managed using code instead of manual configuration through cloud consoles.

---

# Why Terraform is Required

Traditional infrastructure setup involves manual configuration through UI dashboards which becomes difficult when infrastructure grows.

Terraform solves these problems by:

* Automating infrastructure provisioning
* Reducing manual errors
* Maintaining consistency across environments
* Enabling version control for infrastructure
* Supporting reusable infrastructure templates
* Simplifying scaling and modifications

---

# Infrastructure as Code (IaC)

Infrastructure as Code means managing infrastructure using configuration files.

Instead of manually creating:

* EC2 instances
* VPCs
* Subnets
* Security Groups

We define them inside Terraform configuration files.

---

# Terraform Workflow

```text id="9d1mkb"
Write Code
    ↓
terraform init
    ↓
terraform plan
    ↓
terraform apply
    ↓
Infrastructure Created
```

---

# Main Components of Terraform

---

# 1. Providers

Providers are plugins that allow Terraform to communicate with cloud platforms.

### Examples

* AWS
* Azure
* Google Cloud
* GitHub
* Kubernetes

---

# AWS Provider Example

```hcl id="e6kw5v"
provider "aws" {
  region = "us-east-1"
}
```

---

# 2. Resources

Resources define infrastructure components.

### Example Resources

* aws_instance
* aws_vpc
* aws_subnet
* aws_security_group
* aws_db_instance

---

# EC2 Resource Example

```hcl id="h4f9zq"
resource "aws_instance" "web" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
}
```

---

# 3. Variables

Variables are used to make Terraform configurations reusable and dynamic.

---

# Variable Example

```hcl id="h1nvqg"
variable "instance_type" {
  default = "t2.micro"
}
```

---

# 4. Outputs

Outputs display important information after infrastructure creation.

---

# Output Example

```hcl id="q5j2mk"
output "instance_ip" {
  value = aws_instance.web.public_ip
}
```

---

# 5. State File

Terraform stores infrastructure information inside a state file.

### File

```text id="n5k0pr"
terraform.tfstate
```

---

# Why State File is Important

Terraform uses the state file to:

* Track created resources
* Compare infrastructure changes
* Update existing infrastructure
* Prevent duplicate resource creation

---

# Terraform State Workflow

```text id="d4h3sj"
Terraform Code
       ↓
terraform apply
       ↓
terraform.tfstate
       ↓
Tracks Infrastructure
```

---

# Backend in Terraform

A backend stores Terraform state remotely.

---

# Why Backend is Required

* Team collaboration
* Secure state management
* Remote storage
* State locking
* Backup management

---

# Common Backends

| Backend         | Purpose                   |
| --------------- | ------------------------- |
| Local           | Store state locally       |
| S3              | Remote AWS storage        |
| Terraform Cloud | Managed Terraform backend |

---

# S3 Backend Example

```hcl id="j7p2dw"
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
```

---

# Terraform Basic Commands

---

# Initialize Terraform

Downloads provider plugins.

```bash id="k0g9fj"
terraform init
```

---

# Validate Configuration

Checks syntax correctness.

```bash id="s6l0vp"
terraform validate
```

---

# Preview Changes

Shows execution plan before creation.

```bash id="z5k1ur"
terraform plan
```

---

# Apply Infrastructure

Creates resources.

```bash id="w7p4ld"
terraform apply
```

---

# Destroy Infrastructure

Deletes created infrastructure.

```bash id="x7j2nm"
terraform destroy
```

---

# Show Terraform State

```bash id="w3z0ac"
terraform show
```

---

# Format Terraform Files

```bash id="u2k1qa"
terraform fmt
```

---

# Terraform File Structure

| File              | Purpose                       |
| ----------------- | ----------------------------- |
| provider.tf       | Provider configuration        |
| main.tf           | Main infrastructure resources |
| variables.tf      | Variable declarations         |
| outputs.tf        | Output values                 |
| terraform.tfvars  | Variable values               |
| terraform.tfstate | Infrastructure state          |

---

# Example Terraform Project Structure

```text id="h2g7tr"
terraform-project/
│
├── provider.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── terraform.tfstate
```

---

# Installing Terraform in Linux

---

# Download Terraform

```bash id="v7w9ra"
sudo yum install -y yum-utils
```

---

# Add HashiCorp Repository

```bash id="m5r8pc"
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
```

---

# Install Terraform

```bash id="f4d2lw"
sudo yum install terraform -y
```

---

# Verify Installation

```bash id="c2n9yr"
terraform version
```

---

# Terraform Lifecycle

```text id="n4x7jd"
Write Code
    ↓
Initialize
    ↓
Plan
    ↓
Apply
    ↓
Manage State
    ↓
Update Infrastructure
    ↓
Destroy
```

---

# Introduction to Cloud Computing

Cloud Computing is the delivery of computing services over the internet.
Instead of purchasing and maintaining physical servers, users can access resources on-demand from cloud providers.

Cloud platforms provide:

* Servers
* Storage
* Databases
* Networking
* Security
* Monitoring
* AI and Analytics Services

---

# Traditional Infrastructure vs Cloud

| Traditional Infrastructure | Cloud Computing     |
| -------------------------- | ------------------- |
| Physical hardware required | Virtual resources   |
| High upfront cost          | Pay-as-you-go       |
| Manual scaling             | Automatic scaling   |
| Maintenance responsibility | Managed by provider |
| Slow deployment            | Fast provisioning   |

---

# What is Cloud?

Cloud refers to remote servers hosted on the internet that provide services and resources to users whenever required.

---

# Basic Cloud Architecture

```text id="c2p9rm"
User
  ↓
Internet
  ↓
Cloud Provider
  ↓
Virtual Resources
```

---

# Major Cloud Providers

| Provider     | Full Form                   |
| ------------ | --------------------------- |
| AWS          | Amazon Web Services         |
| Azure        | Microsoft Azure             |
| GCP          | Google Cloud Platform       |
| Oracle Cloud | Oracle Cloud Infrastructure |

---

# Advantages of Cloud Computing

* On-demand resource provisioning
* High availability
* Global accessibility
* Scalability
* Reduced infrastructure cost
* Faster deployment
* Automated backup and recovery
* Improved security

---

# Cloud Service Models

Cloud services are divided into different models based on management responsibilities.

---

# 1. IaaS – Infrastructure as a Service

Provides virtualized infrastructure resources.

### Includes

* Virtual Machines
* Storage
* Networking
* Firewalls

### Examples

* AWS EC2
* Azure Virtual Machines
* Google Compute Engine

### User Responsibility

* Operating System
* Application setup
* Security configuration

---

# IaaS Architecture

```text id="m4w2ka"
Cloud Provider
 ├── Physical Servers
 ├── Networking
 └── Virtualization

User
 ├── OS
 ├── Middleware
 ├── Runtime
 └── Applications
```

---

# 2. PaaS – Platform as a Service

Provides a platform for application development and deployment.

### Examples

* AWS Elastic Beanstalk
* Heroku
* Google App Engine

### Benefits

* No server management
* Faster development
* Built-in scaling

---

# 3. SaaS – Software as a Service

Software applications delivered through the internet.

### Examples

* Gmail
* Google Docs
* Microsoft 365
* Zoom

### Features

* Accessible through browser
* No installation required
* Subscription-based usage

---

# Cloud Service Model Comparison

| Feature                   | IaaS | PaaS     | SaaS     |
| ------------------------- | ---- | -------- | -------- |
| Infrastructure Management | User | Provider | Provider |
| OS Management             | User | Provider | Provider |
| Application Deployment    | User | User     | Provider |
| Usage Complexity          | High | Medium   | Low      |

---

# Types of Cloud Computing

---

# 1. Public Cloud

Resources are owned and managed by third-party cloud providers.

### Features

* Shared infrastructure
* Internet-based access
* Cost efficient

### Examples

* AWS
* Azure
* Google Cloud

---

# 2. Private Cloud

Infrastructure dedicated to a single organization.

### Features

* Higher security
* Full control
* Custom environment

### Examples

* Internal company data centers
* VMware private cloud

---

# 3. Hybrid Cloud

Combination of public and private cloud.

### Benefits

* Flexibility
* Better disaster recovery
* Sensitive data can remain private

---

# Cloud Deployment Models

---

# Public Cloud Deployment

```text id="k9t5xr"
Users
   ↓
Public Cloud Provider
   ↓
Shared Infrastructure
```

---

# Private Cloud Deployment

```text id="x3q7np"
Organization
   ↓
Dedicated Infrastructure
```

---

# Hybrid Cloud Deployment

```text id="p4j2vc"
Private Cloud
      ↕
Public Cloud
```

---

# Cloud Characteristics

---

# 1. On-Demand Self Service

Users can create resources whenever needed.

### Example

Creating an EC2 instance instantly.

---

# 2. Broad Network Access

Services are accessible through the internet.

---

# 3. Resource Pooling

Multiple users share cloud resources securely.

---

# 4. Rapid Elasticity

Resources can scale automatically.

### Example

Auto Scaling in AWS.

---

# 5. Measured Service

Users pay only for consumed resources.

---

# Cloud Pricing Models

---

# 1. Pay-As-You-Go

Users pay only for actual usage.

### Example

Hourly EC2 billing.

---

# 2. Reserved Instances

Long-term reserved usage with discounts.

### Benefits

* Lower cost
* Predictable pricing

---

# 3. Spot Instances

Unused cloud resources offered at low prices.

### Limitation

Can terminate anytime.

---

# Cloud Cost Optimization

* Stop unused instances
* Use Auto Scaling
* Monitor resource usage
* Use Reserved Instances
* Delete unused storage

---

# Disaster Recovery (DR)

Disaster Recovery is the process of restoring systems during failures.

---

# Importance of Disaster Recovery

* Minimize downtime
* Protect business continuity
* Prevent data loss
* Improve availability

---

# Disaster Recovery Terms

| Term | Meaning                  |
| ---- | ------------------------ |
| RPO  | Recovery Point Objective |
| RTO  | Recovery Time Objective  |

---

# Disaster Recovery Methods

---

# 1. Backup and Restore

Regularly backup data and restore during failure.

### Low Cost

### Higher Recovery Time

---

# 2. Pilot Light

Minimal infrastructure always running.

### Faster recovery

### Moderate cost

---

# 3. Warm Standby

Small version of production environment running continuously.

### Faster failover

### Higher cost

---

# 4. Multi-Site Active-Active

Full production environments in multiple regions.

### Very high availability

### Expensive

---

# Disaster Recovery Architecture

```text id="h8r1df"
Primary Region
      ↓
Data Replication
      ↓
Secondary Region
      ↓
Recovery During Failure
```

---

# Latency in Cloud Computing

Latency refers to the delay between request and response.

---

# Causes of Latency

* Network distance
* Congestion
* Slow applications
* Database delays
* DNS resolution delay

---

# Types of Latency

| Type                | Description                     |
| ------------------- | ------------------------------- |
| Network Latency     | Delay in network communication  |
| Disk Latency        | Storage read/write delay        |
| Application Latency | Delay in application processing |

---

# Reducing Latency

* Use nearest cloud region
* Enable caching
* Use CDN
* Optimize databases
* Use Load Balancers

---

# AWS Practical Resource Creation

Resources can be created using:

---

# 1. AWS Console

Graphical interface for manual resource creation.

### Examples

* EC2
* VPC
* RDS
* S3

---

# 2. AWS CLI

Command line tool for AWS automation.

### Example

```bash id="d7p4kv"
aws ec2 describe-instances
```

---

# 3. Terraform

Infrastructure as Code automation tool.

### Example

```hcl id="w6n8qr"
resource "aws_instance" "web" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
}
```

---

# Naming Conventions in Cloud

Proper naming standards improve management and monitoring.

---

# Example Naming Format

```text id="f5m2cl"
project-environment-resource
```

### Example

```text id="u9r3qn"
vishnu-prod-webserver
```

---

# AWS Core Services

| Service    | Purpose             |
| ---------- | ------------------- |
| EC2        | Virtual Servers     |
| S3         | Object Storage      |
| RDS        | Managed Database    |
| IAM        | Identity Management |
| VPC        | Networking          |
| CloudWatch | Monitoring          |
| Route53    | DNS                 |
| ELB        | Load Balancer       |

---

# Cloud Security Basics

* IAM users and roles
* MFA
* Security Groups
* Encryption
* Backup policies
* Least privilege access

---

# Real-Time Cloud Architecture

```text id="q8v1tb"
Users
  ↓
Route53
  ↓
Load Balancer
  ↓
EC2 Instances
  ↓
Application
  ↓
RDS Database
```

---
