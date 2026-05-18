

# Introduction to IAM

IAM stands for:

* Identity and Access Management

IAM is an AWS service used to securely control access to AWS resources.

Using IAM, organizations can:

* Create users
* Assign permissions
* Manage authentication
* Control resource access
* Implement security policies

IAM helps enforce:

* Authentication
* Authorization
* Least privilege access

---

# Why IAM is Important

IAM is the foundation of AWS security.

It helps:

* Secure AWS resources
* Prevent unauthorized access
* Manage permissions
* Enable secure cloud operations

---

# IAM Architecture

```text id="f4m8zw"
Users / Applications
        ↓
IAM Authentication
        ↓
Policies & Permissions
        ↓
AWS Resources
```

---

# IAM Components

Main IAM components:

1. IAM Users
2. IAM Groups
3. IAM Roles
4. IAM Policies
5. Access Keys & Secret Keys

---

# 1. IAM User

An IAM User represents an individual person or application that needs access to AWS.

Each IAM user can have:

* Username
* Password
* Access Keys
* Policies
* MFA

---

# IAM User Use Cases

* Employees
* Developers
* DevOps engineers
* Applications
* Automation scripts

---

# Create IAM User

---

# Steps

1. Open AWS Console
2. Go to IAM
3. Select Users
4. Click Create User
5. Enter username
6. Select access type
7. Attach permissions
8. Create user

---

# Example IAM Username

```text id="j8k2vm"
vishnu-devops-intern
```

---

# Types of User Access

| Access Type         | Purpose                |
| ------------------- | ---------------------- |
| Console Access      | AWS Management Console |
| Programmatic Access | CLI, SDK, Terraform    |

---

# Console Password

Used for:

* AWS Console login

---

# Access Key and Secret Key

Used for:

* CLI
* Terraform
* SDK
* Automation

---

# Access Key Example

```text id="p3v8kx"
AKIAXXXXXXXXXXXXX
```

---

# Secret Key Example

```text id="h6m2wr"
xYz123456789SecretKey
```

---

# Important Security Note

Never share:

* Secret Keys
* Access Keys
* Root credentials

---

# 2. IAM Groups

IAM Groups are collections of IAM users.

Groups simplify permission management.

---

# Example Groups

* Admins
* Developers
* DevOps
* ReadOnlyUsers

---

# Group Workflow

```text id="y5p1nb"
Users
  ↓
IAM Group
  ↓
Policies
  ↓
Permissions
```

---

# Benefits of IAM Groups

* Easier permission management
* Centralized access control
* Reduced administration effort

---

# Example

Instead of assigning policies individually:

```text id="d9m4qx"
Developer Group
   ↓
All Developers Inherit Same Permissions
```

---

# 3. IAM Policies

Policies define permissions in AWS.

Policies are written in:

* JSON format

Policies determine:

* Who can access
* What actions are allowed
* Which resources can be accessed

---

# IAM Policy Structure

```json id="g7x4pt"
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
```

---

# Key JSON Policy Elements

| Element   | Purpose                 |
| --------- | ----------------------- |
| Version   | Policy language version |
| Statement | Permission block        |
| Effect    | Allow or Deny           |
| Action    | AWS API actions         |
| Resource  | AWS resources           |
| Condition | Optional restrictions   |

---

# Policy Effects

| Effect | Meaning                     |
| ------ | --------------------------- |
| Allow  | Grant permission            |
| Deny   | Explicitly block permission |

---

# Example Policy

Allow EC2 Read Access:

```json id="v2q8kc"
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances"
      ],
      "Resource": "*"
    }
  ]
}
```

---

# Types of IAM Policies

---

# 1. AWS Managed Policies

Policies created and maintained by AWS.

### Examples

* AdministratorAccess
* AmazonS3ReadOnlyAccess

---

# 2. Customer Managed Policies

Custom policies created by users.

---

# 3. Inline Policies

Policies directly attached to:

* Users
* Roles
* Groups

---

# 4. IAM Roles

IAM Roles provide temporary permissions to trusted entities.

Roles do NOT have:

* Permanent passwords
* Permanent access keys

---

# IAM Role Workflow

```text id="w3z7mb"
User / Service
      ↓
Assume Role
      ↓
Temporary Credentials
      ↓
AWS Resource Access
```

---

# IAM Role Use Cases

* EC2 accessing S3
* Lambda accessing DynamoDB
* Cross-account access
* Temporary elevated access

---

# Example

EC2 Instance Role:

```text id="r4n2kt"
EC2
 ↓
IAM Role
 ↓
S3 Access
```

---

# IAM User vs IAM Role

| IAM User               | IAM Role                  |
| ---------------------- | ------------------------- |
| Permanent identity     | Temporary identity        |
| Long-term credentials  | Temporary credentials     |
| Human users            | AWS services/applications |
| Requires password/keys | Assumed dynamically       |

---

# IAM Role vs IAM Policy

| Role                      | Policy                         |
| ------------------------- | ------------------------------ |
| Identity with permissions | Permission document            |
| Can be assumed            | Defines allowed actions        |
| Used by users/services    | Attached to roles/users/groups |

---

# Least Privilege Principle

Least privilege means:

* Grant only minimum required permissions

---

# Example

Instead of:

```text id="x9m6vd"
s3:*
```

Use:

```text id="y8w2cr"
s3:GetObject
```

---

# Why Least Privilege is Important

* Improves security
* Reduces attack surface
* Prevents accidental damage

---

# MFA – Multi Factor Authentication

MFA adds extra security during login.

---

# MFA Components

1. Password
2. OTP / Authenticator App

---

# Benefits

* Prevents unauthorized access
* Protects root accounts

---

# AWS Root User vs IAM User

| Root User               | IAM User                   |
| ----------------------- | -------------------------- |
| Full AWS access         | Limited permissions        |
| Account owner           | Managed user               |
| Dangerous for daily use | Recommended for operations |

---

# Best Practice

Never use:

* Root account for daily activities

Use:

* IAM users with proper permissions

---

# Programmatic AWS Access

Applications and automation tools access AWS using:

* Access Key
* Secret Key

---

# Tools Using Programmatic Access

* AWS CLI
* Terraform
* SDKs
* CI/CD pipelines

---

# Configure AWS CLI

```bash id="u2p8mc"
aws configure
```

---

# Enter Credentials

```text id="z7x3rt"
AWS Access Key ID:
AWS Secret Access Key:
Region:
Output Format:
```

---

# IAM Best Practices

* Enable MFA
* Follow least privilege
* Rotate access keys
* Avoid root usage
* Use IAM roles instead of hardcoded credentials
* Remove unused users

---

# IAM Policy Evaluation Logic

AWS evaluates:

1. Explicit Deny
2. Explicit Allow
3. Default Deny

---

# IAM Authentication Flow

```text id="k4v7pt"
User Login
    ↓
Authentication
    ↓
Policy Evaluation
    ↓
AWS Resource Access
```

---

# Practical Intern IAM Setup

---

# Create IAM User for Internship

## Steps

1. IAM Console
2. Create User
3. Enable Console Access
4. Attach `AdministratorAccess`
5. Create User
6. Download credentials

---

# Why Admin Permission?

Used for:

* Learning AWS services
* Practicing DevOps
* Terraform automation
* Infrastructure management

---

# Security Warning

Admin permissions should:

* Only be used for learning/testing
* Never shared publicly

---

# Real-Time DevOps Usage

IAM is heavily used for:

* EC2 Roles
* CI/CD pipelines
* Terraform automation
* Kubernetes authentication
* Application access management

---

# Example Production Architecture

```text id="p2r9yf"
Developer
   ↓
IAM User
   ↓
IAM Policies
   ↓
AWS Resources
```

---

# Terraform and IAM

Terraform often uses:

* Access Keys
* IAM Roles

for infrastructure automation.

---

# Example Terraform Authentication

```hcl id="n5q2vb"
provider "aws" {
  region     = "us-east-1"
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
}
```

---
