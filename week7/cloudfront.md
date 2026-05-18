# Week 8 – CloudFront and ACM (AWS Certificate Manager)

# Introduction to CloudFront

Amazon CloudFront is a Content Delivery Network (CDN) service provided by AWS.

It is used to:

* Deliver content faster
* Reduce latency
* Improve performance
* Secure applications
* Cache static and dynamic content globally

CloudFront distributes content through Edge Locations worldwide.

---

# What is a CDN?

CDN stands for:

* Content Delivery Network

A CDN stores cached copies of content in multiple geographical locations to reduce the distance between users and servers.

---

# Basic CloudFront Architecture

```text id="v6m3kp"
User
 ↓
CloudFront Edge Location
 ↓
Origin Server (S3 / EC2 / ALB)
```

---

# How CloudFront Works

1. User requests website content
2. Request reaches nearest Edge Location
3. If cached:

   * Content served immediately
4. If not cached:

   * CloudFront fetches content from Origin
5. Content cached for future requests

---

# Benefits of CloudFront

* Low latency
* Faster content delivery
* Global caching
* HTTPS support
* DDoS protection
* Origin shielding
* Load reduction on origin servers

---

# CloudFront Features

---

# 1. Global Edge Locations

CloudFront uses worldwide edge locations for caching content closer to users.

### Benefits

* Faster loading
* Reduced latency

---

# 2. Content Caching

Frequently accessed content is cached at edge locations.

### Cached Content Examples

* Images
* CSS
* JavaScript
* Videos
* APIs

---

# 3. HTTPS Support

CloudFront supports HTTPS using ACM certificates.

---

# 4. DDoS Protection

Integrated with:

* AWS Shield
* AWS WAF

---

# 5. Origin Access Control (OAC)

Allows secure access between CloudFront and S3.

Prevents direct public S3 access.

---

# 6. Compression

CloudFront supports:

* Gzip
* Brotli

for reduced bandwidth usage.

---

# 7. Custom Domains

CloudFront supports custom domains using:

* Route53
* ACM certificates

---

# Origin Types in CloudFront

CloudFront fetches content from origins.

---

# 1. S3 Bucket Origin

Used for:

* Static websites
* Images
* Assets

---

# 2. EC2 Instance Origin

Used for:

* Dynamic applications
* APIs

---

# 3. Application Load Balancer (ALB)

Used for:

* Scalable applications
* Auto Scaling architectures

---

# CloudFront Request Flow

```text id="r4p8yw"
User
 ↓
DNS Resolution
 ↓
Nearest Edge Location
 ↓
Cache Check
 ↓
Origin Request (if needed)
 ↓
Response Returned
```

---

# CloudFront Behaviors

Behaviors define how CloudFront handles requests.

---

# Behavior Components

| Component              | Purpose             |
| ---------------------- | ------------------- |
| Path Pattern           | Match requests      |
| Cache Policy           | Caching rules       |
| Viewer Protocol Policy | HTTP/HTTPS handling |
| Allowed Methods        | GET/POST control    |

---

# Viewer Protocol Policies

| Policy                 | Purpose            |
| ---------------------- | ------------------ |
| HTTP Only              | HTTP access        |
| Redirect HTTP to HTTPS | Secure redirection |
| HTTPS Only             | Strict HTTPS       |

---

# Cache Policies

Cache policies control:

* Headers
* Cookies
* Query strings
* Cache TTL

---

# TTL (Time To Live)

Defines how long content remains cached.

---

# CloudFront Pricing

CloudFront pricing depends on:

* Data transfer out
* HTTP/HTTPS requests
* Invalidation requests
* Geographic region

---

# Pricing Components

| Component      | Pricing             |
| -------------- | ------------------- |
| Data Transfer  | Per GB              |
| Requests       | Per request         |
| HTTPS Requests | Slightly higher     |
| Invalidation   | Charged after limit |

---

# Cost Optimization Tips

* Enable caching
* Use compression
* Optimize object sizes
* Use correct TTL values

---

# Static Website Hosting with CloudFront

CloudFront is commonly used with S3 static websites.

---

# Architecture

```text id="m7v2tk"
User
 ↓
CloudFront
 ↓
S3 Bucket
```

---

# Benefits

* HTTPS support
* Faster delivery
* CDN caching
* Better security

---

# Steps to Host Static Website with CloudFront

1. Create S3 bucket
2. Upload website files
3. Enable static website hosting
4. Create CloudFront distribution
5. Configure Route53
6. Attach ACM certificate

---

# What is ACM?

ACM stands for:

* AWS Certificate Manager

It is used to:

* Create SSL/TLS certificates
* Manage certificates
* Automatically renew certificates

---

# ACM Features

* Free public certificates
* Automatic renewal
* AWS service integration
* Easy HTTPS configuration

---

# ACM Supported Services

* CloudFront
* ALB
* API Gateway
* Elastic Beanstalk

---

# ACM Certificate Creation

---

# Steps

1. Open ACM Console
2. Request public certificate
3. Enter domain name
4. Choose DNS validation
5. Validate ownership
6. Certificate issued

---

# Example Domain

```text id="g3z5qr"
example.com
www.example.com
```

---

# ACM Validation Methods

| Method           | Description        |
| ---------------- | ------------------ |
| DNS Validation   | Recommended        |
| Email Validation | Traditional method |

---

# DNS Validation Flow

```text id="h5k8xp"
Domain
 ↓
DNS Record Added
 ↓
AWS Verification
 ↓
Certificate Issued
```

---

# ACM Automatic Renewal

ACM automatically renews certificates before expiration.

### Benefits

* No manual renewal
* Reduced downtime risk

---

# HTTPS with CloudFront

CloudFront uses ACM certificates for HTTPS.

---

# HTTPS Request Flow

```text id="y9p3tw"
User
 ↓
HTTPS Request
 ↓
CloudFront
 ↓
ACM Certificate Validation
 ↓
Origin Server
```

---

# CloudFront Distribution

A CloudFront Distribution defines:

* Origin
* Behaviors
* Cache settings
* HTTPS settings

---

# Types of Distributions

| Type              | Purpose            |
| ----------------- | ------------------ |
| Web Distribution  | Websites and APIs  |
| RTMP Distribution | Streaming (legacy) |

---

# CloudFront Distribution Components

| Component        | Purpose          |
| ---------------- | ---------------- |
| Origin           | Source content   |
| Cache Behavior   | Request handling |
| Alternate Domain | Custom domain    |
| SSL Certificate  | HTTPS support    |

---

# Terraform for CloudFront

Terraform automates CloudFront infrastructure.

---

# Basic AWS Provider

```hcl id="f8q1dy"
provider "aws" {
  region = "us-east-1"
}
```

---

# Create S3 Bucket Using Terraform

```hcl id="u4n6xb"
resource "aws_s3_bucket" "static_site" {
  bucket = "vishnu-static-site"
}
```

---

# Upload Website File

```hcl id="x2m9pt"
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.static_site.bucket
  key    = "index.html"
  source = "./index.html"
  content_type = "text/html"
}
```

---

# Create ACM Certificate

```hcl id="j6p3ws"
resource "aws_acm_certificate" "cert" {
  domain_name       = "example.com"
  validation_method = "DNS"
}
```

---

# Create CloudFront Distribution

```hcl id="w3v8ky"
resource "aws_cloudfront_distribution" "cdn" {

  origin {
    domain_name = aws_s3_bucket.static_site.bucket_regional_domain_name
    origin_id   = "s3-origin"
  }

  enabled = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-origin"

    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
```

---

# Terraform Workflow

```text id="d4k8zp"
Write Terraform Code
        ↓
terraform init
        ↓
terraform plan
        ↓
terraform apply
        ↓
CloudFront Distribution Created
```

---

# Terraform Files Structure

```text id="b9r4mt"
terraform-cloudfront/
│
├── provider.tf
├── main.tf
├── variables.tf
├── outputs.tf
└── terraform.tfvars
```

---

# Access Website Through CloudFront

```text id="q2m7rw"
https://d123abc.cloudfront.net
```

---

# Route53 Integration

Custom domains can be mapped to CloudFront distributions.

---

# Route53 Flow

```text id="k7w3fx"
User
 ↓
Route53
 ↓
CloudFront
 ↓
S3 Bucket
```

---

# CloudFront Security Features

* HTTPS enforcement
* AWS Shield integration
* AWS WAF support
* Origin Access Control
* Geo restrictions

---

# CloudFront Monitoring

CloudFront metrics available in:

* CloudWatch

### Metrics

* Requests
* Cache hit ratio
* Errors
* Data transfer

---

# Real-Time DevOps Usage

CloudFront is widely used for:

* Static website hosting
* Global application delivery
* API acceleration
* CDN caching
* Media streaming
* Secure HTTPS hosting

---

# Cost Estimation Tags

Proper tagging helps in:

* Billing
* Resource tracking
* Cost allocation

---

# Example Tags

```hcl id="m1z8cp"
tags = {
  Environment = "Dev"
  Project     = "CloudFrontDemo"
}
```

---

# Best Practices

* Use HTTPS only
* Enable compression
* Configure proper caching
* Use OAC instead of public S3 buckets
* Enable logging
* Use lifecycle management

---

# Final Production Architecture

```text id="v0p4yn"
User
 ↓
Route53
 ↓
CloudFront CDN
 ↓
S3 Static Website
```

---
