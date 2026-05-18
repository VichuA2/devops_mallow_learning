# Managing Amazon S3 Using Terraform

Terraform can be used to fully automate the lifecycle of S3 buckets including:

* Creating buckets
* Managing bucket configuration
* Uploading objects
* Accessing bucket resources
* Updating bucket settings
* Deleting buckets

---

# Terraform Workflow for S3

```text id="m8z4kt"
Write Terraform Code
        ↓
terraform init
        ↓
terraform plan
        ↓
terraform apply
        ↓
S3 Resources Created
```

---

# Step 1 – Configure AWS Provider

Terraform uses providers to connect with AWS.

---

# provider.tf

```hcl id="q4p8vw"
provider "aws" {
  region = "us-east-1"
}
```

---

# Step 2 – Create an S3 Bucket

The `aws_s3_bucket` resource is used to create buckets.

---

# main.tf

```hcl id="z7n2ld"
resource "aws_s3_bucket" "demo_bucket" {
  bucket = "vishnu-demo-terraform-bucket"

  tags = {
    Name        = "TerraformBucket"
    Environment = "Dev"
  }
}
```

---

# Explanation

| Argument | Purpose           |
| -------- | ----------------- |
| bucket   | Bucket name       |
| tags     | Resource metadata |

---

# Initialize Terraform

Downloads AWS provider plugins.

```bash id="w1k5mp"
terraform init
```

---

# Preview Infrastructure

```bash id="u9r3vc"
terraform plan
```

---

# Create S3 Bucket

```bash id="n6x2qp"
terraform apply
```

---

# Confirm Resource Creation

```text id="c5m8za"
Enter a value: yes
```

---

# Result

Terraform creates:

* S3 Bucket
* State file
* Resource tracking

---

# Verify Bucket in AWS Console

```text id="g8v4tr"
AWS Console → S3 → Buckets
```

---

# Step 3 – Enable Versioning

Versioning protects against accidental deletion.

---

# Enable Versioning

```hcl id="t3x9kp"
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.demo_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
```

---

# Step 4 – Configure Bucket Security

Terraform can configure bucket permissions and security policies.

---

# Block Public Access

```hcl id="f5j2rn"
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.demo_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

---

# Step 5 – Enable Static Website Hosting

Terraform can configure S3 static website hosting.

---

# Website Configuration

```hcl id="y2m7qd"
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.demo_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
```

---

# Website Endpoint

```text id="v9k3tb"
http://bucket-name.s3-website-us-east-1.amazonaws.com
```

---

# Step 6 – Upload Files to S3

Terraform can upload files as S3 objects.

---

# Upload index.html

```hcl id="d8n4wr"
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.demo_bucket.bucket
  key    = "index.html"
  source = "./index.html"
  acl    = "public-read"

  content_type = "text/html"
}
```

---

# Explanation

| Argument     | Purpose           |
| ------------ | ----------------- |
| key          | Object name       |
| source       | Local file path   |
| acl          | Access permission |
| content_type | File MIME type    |

---

# Step 7 – Configure Bucket Policy

Bucket policy allows public website access.

---

# Public Read Policy

```hcl id="p4v6xz"
resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.demo_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicRead"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.demo_bucket.arn}/*"
    }]
  })
}
```

---

# Step 8 – Access S3 Bucket

Buckets can be accessed through:

---

# 1. AWS Console

```text id="e5j1rh"
AWS Console → S3
```

---

# 2. AWS CLI

List buckets:

```bash id="a8m2vc"
aws s3 ls
```

View bucket contents:

```bash id="g2q7xp"
aws s3 ls s3://vishnu-demo-terraform-bucket
```

---

# 3. Browser Access

Static website endpoint:

```text id="s7n4zy"
http://bucket-name.s3-website-region.amazonaws.com
```

---

# Step 9 – Modify Existing Bucket

Terraform automatically detects configuration changes.

---

# Example Modification

Enable bucket encryption.

```hcl id="h4p8mt"
resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt" {
  bucket = aws_s3_bucket.demo_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

---

# Apply Changes

```bash id="j6w3fc"
terraform apply
```

---

# Step 10 – Terraform State Management

Terraform stores resource information in:

```text id="r9d5kl"
terraform.tfstate
```

---

# Why State File is Important

Terraform uses the state file to:

* Track infrastructure
* Detect changes
* Update resources
* Avoid duplication

---

# Step 11 – Delete S3 Resources

Terraform can destroy infrastructure completely.

---

# Destroy Infrastructure

```bash id="t1x9vr"
terraform destroy
```

---

# Confirmation

```text id="m3q7yc"
Enter a value: yes
```

---

# Result

Terraform deletes:

* S3 bucket
* Uploaded objects
* Policies
* Configurations

---

# Important Note About Bucket Deletion

S3 buckets cannot be deleted if objects exist inside them.

---

# Force Delete Bucket

```hcl id="u6n2pa"
resource "aws_s3_bucket" "demo_bucket" {
  bucket        = "vishnu-demo-terraform-bucket"
  force_destroy = true
}
```

---

# What force_destroy Does

Automatically deletes:

* Files
* Versions
* Objects

before deleting the bucket.

---

# Terraform File Structure for S3 Project

```text id="x4k8dw"
terraform-s3/
│
├── provider.tf
├── main.tf
├── variables.tf
├── outputs.tf
└── terraform.tfstate
```

---

# Example Output

```hcl id="v5q1te"
output "bucket_name" {
  value = aws_s3_bucket.demo_bucket.bucket
}
```

---

# View Outputs

```bash id="w7p2cz"
terraform output
```

---

# Best Practices

* Use versioning
* Enable encryption
* Block public access unless required
* Store state remotely
* Use lifecycle policies
* Use meaningful naming conventions

---

# Real-Time Terraform S3 Workflow

```text id="n2y8qr"
Developer
    ↓
Terraform Code
    ↓
AWS Provider
    ↓
S3 Bucket Creation
    ↓
Website Hosting / Storage
```

---

# Advantages of Managing S3 with Terraform

* Infrastructure automation
* Reusable configurations
* Version-controlled infrastructure
* Faster deployment
* Easy modifications
* Consistent environments

---

# Real-Time Use Cases

* Static website hosting
* Backup storage
* Application asset storage
* Log archival
* CI/CD artifact storage

---
