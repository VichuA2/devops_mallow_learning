
# Introduction to VPC

VPC stands for:

* Virtual Private Cloud

A VPC is a logically isolated virtual network inside AWS where cloud resources are launched.

Using a VPC, users can:

* Create private networks
* Control traffic flow
* Configure subnets
* Secure infrastructure
* Design cloud architectures

---

# Why VPC is Important

VPC provides:

* Network isolation
* Security control
* Custom IP ranges
* Internet connectivity management
* Scalable cloud networking

---

# Basic VPC Architecture

```text id="n4v7pd"
AWS Cloud
   ↓
VPC
 ├── Public Subnet
 ├── Private Subnet
 ├── Route Tables
 ├── NAT Gateway
 ├── Internet Gateway
 └── Security Components
```

---

# IP Addressing Concepts

---

# Public IP Address

A Public IP is accessible over the internet.

### Features

* Globally unique
* Internet routable
* Used for public access

### Examples

* Web servers
* Load balancers

---

# Private IP Address

Private IPs are used inside internal networks.

### Features

* Internal communication only
* Not directly accessible from internet

### Example Ranges

```text id="j3w9km"
10.0.0.0/8
172.16.0.0/12
192.168.0.0/16
```

---

# IPv4

IPv4 uses:

* 32-bit addressing

### Example

```text id="v5x8pa"
192.168.1.10
```

---

# IPv6

IPv6 uses:

* 128-bit addressing

### Example

```text id="m7k3dx"
2001:db8::1
```

---

# IPv4 vs IPv6

| Feature       | IPv4    | IPv6        |
| ------------- | ------- | ----------- |
| Address Size  | 32-bit  | 128-bit     |
| Format        | Decimal | Hexadecimal |
| Address Space | Limited | Very Large  |
| NAT Required  | Yes     | Usually No  |

---

# VPC (Virtual Private Cloud)

A VPC is an isolated network inside AWS.

---

# VPC Features

* Custom IP ranges
* Public and private subnets
* Route table configuration
* Internet connectivity control
* Security isolation

---

# CIDR Block

CIDR stands for:

* Classless Inter-Domain Routing

CIDR defines IP address ranges.

---

# Example CIDR

```text id="x9v3kt"
10.0.0.0/16
```

---

# CIDR Breakdown

| Part     | Meaning         |
| -------- | --------------- |
| 10.0.0.0 | Network address |
| /16      | Subnet mask     |

---

# Common CIDR Examples

| CIDR | Available IPs |
| ---- | ------------- |
| /24  | 256           |
| /16  | 65,536        |
| /8   | Large network |

---

# Subnets

Subnets divide a VPC into smaller networks.

---

# Types of Subnets

---

# 1. Public Subnet

A subnet with internet access.

### Features

* Connected to Internet Gateway
* Public IP assignment possible

### Example Resources

* Web servers
* Load balancers

---

# 2. Private Subnet

A subnet without direct internet access.

### Features

* No public IP
* More secure

### Example Resources

* Databases
* Internal applications

---

# Public vs Private Subnet

| Public Subnet         | Private Subnet     |
| --------------------- | ------------------ |
| Internet accessible   | Internal only      |
| Public IP supported   | No direct internet |
| Uses Internet Gateway | Uses NAT Gateway   |

---

# Internet Gateway (IGW)

An Internet Gateway enables communication between:

* VPC
* Internet

---

# Internet Gateway Features

* Internet connectivity
* Public traffic routing
* Bidirectional communication

---

# Internet Gateway Flow

```text id="h8r2vc"
Internet
   ↓
Internet Gateway
   ↓
Public Subnet
```

---

# NAT Gateway

NAT stands for:

* Network Address Translation

NAT Gateway allows private subnet instances to access the internet without exposing them publicly.

---

# NAT Gateway Use Cases

* Software updates
* Package installation
* API access from private instances

---

# NAT Gateway Flow

```text id="t5v8zn"
Private EC2
     ↓
NAT Gateway
     ↓
Internet Gateway
     ↓
Internet
```

---

# Route Tables

Route tables define network traffic paths.

---

# Route Table Components

| Component   | Purpose          |
| ----------- | ---------------- |
| Destination | Target network   |
| Target      | Gateway or route |

---

# Public Route Table

```text id="q4n7rm"
0.0.0.0/0 → Internet Gateway
```

Used for:

* Public subnet internet access

---

# Private Route Table

```text id="n8k1vc"
0.0.0.0/0 → NAT Gateway
```

Used for:

* Outbound internet access from private subnet

---

# Route Table Flow

```text id="m6r3kp"
Subnet
   ↓
Route Table
   ↓
Gateway
   ↓
Destination
```

---

# Security Groups

Security Groups act as virtual firewalls for EC2 instances.

---

# Security Group Features

* Stateful firewall
* Instance-level security
* Allow rules only

---

# Example Rules

| Type  | Port |
| ----- | ---- |
| SSH   | 22   |
| HTTP  | 80   |
| HTTPS | 443  |

---

# Security Group Traffic Flow

```text id="z7v4pd"
Inbound Rules
      ↓
EC2 Instance
      ↓
Outbound Rules
```

---

# Network ACL (NACL)

NACL acts as subnet-level firewall protection.

---

# NACL Features

* Stateless firewall
* Allow and deny rules
* Subnet-level control

---

# NACL Rule Example

| Rule     | Action |
| -------- | ------ |
| Allow 80 | HTTP   |
| Deny 23  | Telnet |

---

# Security Group vs NACL

| Security Group    | NACL           |
| ----------------- | -------------- |
| Stateful          | Stateless      |
| Instance level    | Subnet level   |
| Allow rules only  | Allow and deny |
| Easier management | More granular  |

---

# Traffic Flow Example

---

# Public EC2 Internet Flow

```text id="g4x2tm"
Internet
   ↓
Internet Gateway
   ↓
Public Route Table
   ↓
Public Subnet
   ↓
EC2 Instance
```

---

# Private EC2 Internet Flow

```text id="q9w5rk"
Private EC2
     ↓
Private Route Table
     ↓
NAT Gateway
     ↓
Internet Gateway
     ↓
Internet
```

---

# VPC Components in AWS Console

Main VPC Console Components:

| Component        | Purpose                 |
| ---------------- | ----------------------- |
| VPC              | Virtual network         |
| Subnets          | Network segmentation    |
| Route Tables     | Traffic routing         |
| Internet Gateway | Public internet         |
| NAT Gateway      | Private internet access |
| Security Groups  | Instance firewall       |
| NACL             | Subnet firewall         |

---

# Creating VPC Using AWS Console

---

# Steps

1. Open VPC Console
2. Create VPC
3. Add CIDR block
4. Create public subnet
5. Create private subnet
6. Create Internet Gateway
7. Attach IGW to VPC
8. Create NAT Gateway
9. Configure route tables
10. Associate subnets

---

# Terraform for VPC

Terraform automates VPC infrastructure creation.

---

# Step 1 – Configure AWS Provider

Terraform uses the AWS provider to connect with AWS services.

---

# provider.tf

```hcl id="p7x3kd"
provider "aws" {
  region = "us-east-1"
}
```

---

# Step 2 – Create a VPC

A VPC creates an isolated network inside AWS.

---

# main.tf

```hcl id="x9v2rp"
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vishnu-vpc"
  }
}
```

---

# Explanation

| Argument   | Purpose          |
| ---------- | ---------------- |
| cidr_block | IP range for VPC |
| tags       | Resource naming  |

---

# Step 3 – Create Public Subnet

Public subnet allows internet-accessible resources.

---

# Public Subnet Terraform Code

```hcl id="m4k8zn"
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}
```

---

# Step 4 – Create Private Subnet

Private subnet is used for internal resources.

---

# Private Subnet Terraform Code

```hcl id="j5x9tm"
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet"
  }
}
```

---

# Step 5 – Create Internet Gateway

Internet Gateway provides internet access for public subnet resources.

---

# Internet Gateway Code

```hcl id="z3r7pk"
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main-igw"
  }
}
```

---

# Internet Traffic Flow

```text id="f6m1vq"
Internet
   ↓
Internet Gateway
   ↓
Public Subnet
   ↓
Public EC2
```

---

# Step 6 – Create Public Route Table

Route tables define traffic routing rules.

---

# Public Route Table

```hcl id="w8k2zn"
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}
```

---

# Step 7 – Associate Public Route Table

Associates route table with public subnet.

---

# Route Table Association

```hcl id="n7x4tr"
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
```

---

# Step 8 – Create Elastic IP for NAT Gateway

NAT Gateway requires an Elastic IP.

---

# Elastic IP Code

```hcl id="q2m9vk"
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}
```

---

# Step 9 – Create NAT Gateway

NAT Gateway provides outbound internet access for private subnet resources.

---

# NAT Gateway Code

```hcl id="r4k8xp"
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "main-nat-gateway"
  }
}
```

---

# Private Subnet Internet Flow

```text id="v1p6tm"
Private EC2
     ↓
Private Route Table
     ↓
NAT Gateway
     ↓
Internet Gateway
     ↓
Internet
```

---

# Step 10 – Create Private Route Table

Private route table uses NAT Gateway.

---

# Private Route Table Code

```hcl id="h8x2pr"
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private-route-table"
  }
}
```

---

# Step 11 – Associate Private Route Table

```hcl id="t5v9kn"
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
```

---

# Step 12 – Create Security Group

Security Groups act as virtual firewalls.

---

# Security Group Code

```hcl id="p8m3zr"
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

---

# Step 13 – Create Public EC2 Instance

Public EC2 is accessible from the internet.

---

# Public EC2 Code

```hcl id="u7x4pk"
resource "aws_instance" "public_ec2" {
  ami                    = "ami-123456"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "public-ec2"
  }
}
```

---

# Step 14 – Create Private EC2 Instance

Private EC2 remains internal.

---

# Private EC2 Code

```hcl id="m6r8xt"
resource "aws_instance" "private_ec2" {
  ami                    = "ami-123456"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "private-ec2"
  }
}
```

---

# Terraform Commands

---

# Initialize Terraform

```bash id="g2k9pw"
terraform init
```

---

# Validate Configuration

```bash id="d5m1zr"
terraform validate
```

---

# Preview Changes

```bash id="k8r4tx"
terraform plan
```

---

# Create Infrastructure

```bash id="q7v3pn"
terraform apply
```

---

# Delete Infrastructure

```bash id="f1x6km"
terraform destroy
```

---

# Terraform State File

Terraform stores infrastructure details in:

```text id="h3m8vq"
terraform.tfstate
 ```

