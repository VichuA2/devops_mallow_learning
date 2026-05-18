
# Introduction to Amazon RDS

Amazon RDS stands for:

* Relational Database Service

RDS is a managed database service provided by AWS used to run relational databases in the cloud.

RDS helps automate:

* Database provisioning
* Backups
* Patching
* Monitoring
* Scaling
* High availability

---

# Why RDS is Important

Without RDS:

```text id="m4v8pt"
Manual Database Setup
       ↓
Backup Management
       ↓
Patching
       ↓
Monitoring Complexity
```

Problems:

* Operational overhead
* Maintenance complexity
* Backup management issues

---

# With RDS

```text id="x7k2pr"
Application
    ↓
Amazon RDS
    ↓
Managed Database
```

Benefits:

* Automated management
* High availability
* Easy scaling
* Automated backups

---

# RDS Architecture

```text id="q5v1mk"
Application Server
        ↓
Amazon RDS
        ↓
Database Storage
```

---

# Features of Amazon RDS

* Managed database service
* Automated backups
* Multi-AZ high availability
* Read replicas
* Monitoring integration
* Encryption support
* Automated patching

---

# Supported RDS Database Engines

AWS supports multiple database engines.

---

# 1. MySQL

Open-source relational database.

### Use Cases

* Web applications
* CMS applications
* PHP applications

---

# 2. PostgreSQL

Advanced open-source relational database.

### Features

* ACID compliance
* Advanced SQL support

---

# 3. MariaDB

MySQL-compatible open-source database.

---

# 4. Oracle

Enterprise relational database.

---

# 5. Microsoft SQL Server

Used for:

* Windows enterprise applications

---

# 6. Amazon Aurora

AWS-optimized relational database.

### Benefits

* High performance
* High availability
* Better scalability

---

# DB Engine Comparison

| Engine     | Use Case                      |
| ---------- | ----------------------------- |
| MySQL      | Web applications              |
| PostgreSQL | Enterprise workloads          |
| MariaDB    | Open-source compatibility     |
| Aurora     | High-performance applications |
| Oracle     | Enterprise ERP                |
| SQL Server | Microsoft workloads           |

---

# RDS Instance Families

RDS instance classes determine:

* CPU
* Memory
* Performance

---

# Instance Family Types

| Family   | Purpose             |
| -------- | ------------------- |
| T Series | Burstable workloads |
| M Series | General purpose     |
| R Series | Memory optimized    |

---

# Example Instance Classes

| Instance Class | Usage                      |
| -------------- | -------------------------- |
| db.t3.micro    | Small development DB       |
| db.t3.medium   | Medium workloads           |
| db.r5.large    | Memory-intensive workloads |

---

# RDS Storage Types

---

# 1. General Purpose SSD (gp3)

Balanced price and performance.

---

# 2. Provisioned IOPS SSD

High-performance storage.

### Use Cases

* Production databases
* High transaction workloads

---

# 3. Magnetic Storage

Older low-cost storage option.

---

# High Availability in RDS

RDS supports:

* Multi-AZ deployment

for high availability.

---

# Multi-AZ Architecture

```text id="t8v3xp"
Primary DB
    ↓
Synchronous Replication
    ↓
Standby DB
```

---

# Benefits of Multi-AZ

* Automatic failover
* Better availability
* Disaster recovery

---

# Read Replicas

Read replicas improve read performance.

---

# Read Replica Workflow

```text id="k4m9tr"
Primary Database
       ↓
Replication
       ↓
Read Replica
```

---

# Use Cases

* Read-heavy applications
* Reporting systems

---

# Automated Backups

RDS automatically creates:

* Database backups
* Transaction logs

---

# Backup Features

* Point-in-time recovery
* Automated snapshots
* Backup retention

---

# Backup Workflow

```text id="n7x2vp"
Database
    ↓
Automated Backup
    ↓
Recovery Storage
```

---

# Backup Retention Period

Example:

* 7 days
* 30 days

---

# Manual Snapshots

Users can manually create:

* DB snapshots

for backup and migration.

---

# RDS Security

RDS provides multiple security mechanisms.

---

# Security Features

* Security Groups
* IAM authentication
* Encryption
* Private subnet deployment
* SSL connections

---

# Security Group Example

Allow MySQL access:

| Port | Purpose    |
| ---- | ---------- |
| 3306 | MySQL      |
| 5432 | PostgreSQL |

---

# RDS Encryption

Encryption protects:

* Data at rest
* Snapshots
* Replicas

---

# Encryption Methods

| Method               | Description        |
| -------------------- | ------------------ |
| AWS Managed KMS      | Default encryption |
| Customer Managed KMS | Custom keys        |

---

# RDS Maintenance

AWS performs:

* Patching
* Minor upgrades
* Maintenance operations

during maintenance windows.

---

# Maintenance Window

Example:

* Sunday 2 AM – 3 AM

---

# RDS Monitoring

Monitoring available through:

* CloudWatch

---

# Important Metrics

* CPU Utilization
* Free Storage
* Database Connections
* Read/Write IOPS

---

# RDS Pricing

RDS pricing depends on:

* Instance type
* Storage
* Backup storage
* Multi-AZ
* Data transfer

---

# Pricing Components

| Component   | Pricing            |
| ----------- | ------------------ |
| DB Instance | Hourly             |
| Storage     | Per GB             |
| Backups     | Additional storage |
| Multi-AZ    | Additional cost    |

---

# Cost Optimization Tips

* Use smaller instances for development
* Delete unused snapshots
* Disable Multi-AZ in dev environments
* Monitor storage usage

---

# RDS Networking

RDS instances are deployed inside:

* VPC

---

# Best Practice

Deploy RDS inside:

* Private subnets

---

# RDS Traffic Flow

```text id="y3k7pn"
Application Server
        ↓
Security Group
        ↓
Private RDS Instance
```

---

# RDS in AWS Console

Important RDS Console Options:

| Option           | Purpose             |
| ---------------- | ------------------- |
| Databases        | DB instances        |
| Snapshots        | Backups             |
| Parameter Groups | DB configuration    |
| Option Groups    | Additional features |
| Subnet Groups    | Networking          |

---

# Parameter Groups

Parameter Groups manage:

* Database engine settings

---

# Example Parameters

* max_connections
* query_cache_size

---

# Subnet Groups

Subnet Groups define:

* Which subnets RDS can use

---

# RDS Endpoint

Applications connect using:

* RDS endpoint

---

# Example Endpoint

```text id="p9m4xr"
mydb.c123abc.us-east-1.rds.amazonaws.com
```

---

# Terraform for RDS

Terraform automates:

* RDS creation
* Networking
* Security
* Backups

---

# AWS Provider

```hcl id="w5k2vt"
provider "aws" {
  region = "us-east-1"
}
```

---

# Create DB Subnet Group

```hcl id="u7x4pr"
resource "aws_db_subnet_group" "db_subnet" {
  name = "db-subnet-group"

  subnet_ids = [
    aws_subnet.private1.id,
    aws_subnet.private2.id
  ]
}
```

---

# Create Security Group

```hcl id="m8v1tk"
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [
      aws_security_group.app_sg.id
    ]
  }
}
```

---

# Create RDS Instance

```hcl id="x2k9pm"
resource "aws_db_instance" "mysql_db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "myappdb"
  username             = "admin"
  password             = "password123"

  multi_az             = true
  storage_encrypted    = true
  backup_retention_period = 7

  db_subnet_group_name = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  skip_final_snapshot = true
}
```

---

# Explanation

| Argument                | Purpose           |
| ----------------------- | ----------------- |
| engine                  | Database engine   |
| instance_class          | DB instance size  |
| multi_az                | High availability |
| storage_encrypted       | Encryption        |
| backup_retention_period | Automated backups |

---

# Terraform Workflow

```text id="f6m3xp"
Write Terraform Code
        ↓
terraform init
        ↓
terraform plan
        ↓
terraform apply
        ↓
RDS Infrastructure Created
```

---

# RDS Connection Example

MySQL connection:

```bash id="k3v8tr"
mysql -h endpoint -u admin -p
```

---

# High Availability Architecture

```text id="v4m7pk"
Application
    ↓
Primary RDS
    ↓
Standby RDS (Multi-AZ)
```

---

