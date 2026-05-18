# Certbot and SSL Certificate Generation

## What is Certbot?

Certbot is an open-source tool used to generate and manage free SSL/TLS certificates from Let’s Encrypt.

It helps enable HTTPS on websites by automatically:

* Generating SSL certificates
* Configuring HTTPS
* Renewing certificates automatically

---

# Why SSL Certificates are Required

SSL certificates provide:

* Secure encrypted communication
* HTTPS support
* Data protection
* Browser trust
* Improved security

---

# HTTP vs HTTPS

| HTTP                    | HTTPS                    |
| ----------------------- | ------------------------ |
| Unsecured communication | Encrypted communication  |
| Uses Port 80            | Uses Port 443            |
| No SSL certificate      | Requires SSL certificate |
| Vulnerable to attacks   | Secure transmission      |

---

# What is Let’s Encrypt?

Let’s Encrypt is a free Certificate Authority (CA) that issues SSL certificates.

### Benefits

* Free SSL certificates
* Automated renewal
* Trusted by browsers
* Easy integration

---

# Certbot Workflow

```text id="pz7vqm"
Domain
   ↓
Certbot
   ↓
Let's Encrypt Verification
   ↓
SSL Certificate Generated
   ↓
HTTPS Enabled
```

---

# Prerequisites Before Certificate Generation

* Domain name configured
* DNS properly mapped to server IP
* Nginx or Apache installed
* Port 80 and 443 allowed in Security Group

---

# Install Certbot for Nginx

## Amazon Linux / CentOS

```bash id="x8f1kt"
sudo yum install epel-release -y
```

```bash id="n7m4qa"
sudo yum install certbot python3-certbot-nginx -y
```

---

# Ubuntu / Debian

```bash id="g5p2cd"
sudo apt update
```

```bash id="q9v7er"
sudo apt install certbot python3-certbot-nginx -y
```

---

# Verify Nginx Configuration

Before generating certificates:

```bash id="k1w8zr"
sudo nginx -t
```

---

# Restart Nginx

```bash id="r3p5vc"
sudo systemctl restart nginx
```

---

# Generate SSL Certificate

```bash id="m2d9fh"
sudo certbot --nginx -d example.com -d www.example.com
```

---

# During Certificate Generation

Certbot performs:

1. Domain ownership verification
2. SSL certificate generation
3. Nginx HTTPS configuration
4. Automatic redirection setup

---

# Successful Certificate Installation

```text id="j6x4qp"
Congratulations!
Your certificate and chain have been saved.
```

---

# SSL Certificate Storage Location

```text id="s2b8yd"
/etc/letsencrypt/live/example.com/
```

---

# Important Certificate Files

| File          | Purpose         |
| ------------- | --------------- |
| fullchain.pem | SSL certificate |
| privkey.pem   | Private key     |

---

# HTTPS Nginx Configuration

```nginx id="h4v9wc"
server {
    listen 443 ssl;
    server_name example.com;

    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    location / {
        proxy_pass http://localhost:3000;
    }
}
```

---

# Redirect HTTP to HTTPS

```nginx id="e8m2ta"
server {
    listen 80;
    server_name example.com;
    return 301 https://$host$request_uri;
}
```

---

# Test HTTPS

Open browser:

```text id="w5u1kb"
https://example.com
```

---

# Verify SSL Certificate

```bash id="c7r3la"
sudo certbot certificates
```

---

# Auto Renewal of Certificates

Let’s Encrypt certificates expire every 90 days.

Certbot supports automatic renewal.

---

# Test Auto Renewal

```bash id="u9y4hn"
sudo certbot renew --dry-run
```

---

# Restart Nginx After Renewal

```bash id="f6x2jr"
sudo systemctl restart nginx
```

---

# Check HTTPS Port

```bash id="n4c7mv"
sudo lsof -i :443
```

---

# Security Group Rules Required

| Port | Purpose |
| ---- | ------- |
| 80   | HTTP    |
| 443  | HTTPS   |

---

# SSL/TLS Handshake Process

```text id="a2m5pd"
Browser
   ↓
Client Hello
   ↓
Server Certificate
   ↓
Key Exchange
   ↓
Encrypted Connection Established
```

---

# Benefits of HTTPS

* Data encryption
* Secure login protection
* Browser trust
* SEO improvement
* Secure API communication

---

# Real-Time Production Flow

```text id="v8t4ks"
User
 ↓
HTTPS Request
 ↓
Nginx Web Server
 ↓
SSL Certificate Validation
 ↓
Application Server
 ↓
Database
```

---

# Common Certbot Commands

| Command              | Purpose              |
| -------------------- | -------------------- |
| certbot --nginx      | Generate certificate |
| certbot certificates | View certificates    |
| certbot renew        | Renew certificates   |
| certbot delete       | Delete certificate   |

---

# Troubleshooting SSL Issues

## Check Nginx Syntax

```bash id="z3j6rc"
sudo nginx -t
```

---

## Restart Nginx

```bash id="p7n1vk"
sudo systemctl restart nginx
```

---

## Check Firewall / Security Group

Ensure:

* Port 80 open
* Port 443 open

---
