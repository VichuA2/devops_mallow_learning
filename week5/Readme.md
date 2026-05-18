# Week 5 – Web Servers, Apache, Nginx, HTTPS & SSL/TLS

# 1. What is a Web Server?

A web server is software responsible for:

* Receiving HTTP/HTTPS requests from clients
* Processing requests
* Returning responses such as web pages, APIs, images, or files

A web server acts as the communication bridge between users and backend applications.

---

# Basic Web Request Flow

```text id="1v9v7m"
Browser → Internet → Web Server → Response → Browser
```

---

# Responsibilities of a Web Server

* Handle client requests
* Serve static content
* Forward requests to application servers
* Manage HTTPS encryption
* Logging and monitoring
* Load balancing
* Reverse proxying

---
# 2. What is an Application Server?

An application server is software responsible for:

* Executing backend business logic
* Processing dynamic requests
* Interacting with databases
* Managing application sessions
* Returning dynamic responses to users

An application server works between the web server and the database to process application logic.

---

# Basic Application Request Flow

```text id="1r8v6m"
Browser → Web Server → Application Server → Database → Response → Browser
```

---

# Responsibilities of an Application Server

* Execute backend application code
* Handle dynamic content generation
* Connect and communicate with databases
* Process APIs and business logic
* Manage user sessions
* Handle authentication and authorization
* Process application-level requests
* Return dynamic responses to web servers

---

# Features of an Application Server

* Dynamic content processing
* Database connectivity
* Session management
* Middleware support
* Scalability support
* API handling
* Security integration

---

# Examples of Application Servers

| Technology | Usage                     |
| ---------- | ------------------------- |
| Puma       | Ruby on Rails             |
| Tomcat     | Java Applications         |
| Gunicorn   | Python Django/Flask       |
| Node.js    | JavaScript Applications   |
| Unicorn    | Ruby Applications         |
| Passenger  | Rails + Nginx Integration |

---

# Real-Time Architecture Example

```text id="7n3qkp"
User
 ↓
Nginx Web Server
 ↓
Puma Application Server
 ↓
MySQL Database
```

---

# Ports Used in Web Communication

| Port | Protocol |
| ---- | -------- |
| 80   | HTTP     |
| 443  | HTTPS    |

---

# 2. Types of Website Content

---

# Static Content

Static files are directly served by the web server without backend processing.

### Examples

* HTML files
* CSS files
* JavaScript files
* Images
* Videos

### Characteristics

* Fast delivery
* No database interaction
* Minimal server processing

---

# Dynamic Content

Dynamic content is generated at runtime using backend applications and databases.

### Examples

* Login systems
* Shopping carts
* APIs
* Dashboards

### Characteristics

* Backend processing required
* Database interaction
* User-specific responses

---

# 3. Popular Web Servers

The two most popular web servers are:

1. Apache HTTP Server
2. Nginx

---

# 4. Apache Web Server

Apache is one of the oldest and most widely used web servers.

---

# Features of Apache

* Modular architecture
* Highly customizable
* Supports `.htaccess`
* Dynamic content handling
* SSL support
* URL rewriting
* Authentication support

---

# Apache Workflow

```text id="rmh2vp"
Client Request
       ↓
Apache Server
       ↓
Modules Process Request
       ↓
HTTP Response Returned
```

---

# Apache Modules

Apache uses modules to extend functionality.

| Module      | Purpose        |
| ----------- | -------------- |
| mod_http    | HTTP handling  |
| mod_ssl     | HTTPS support  |
| mod_rewrite | URL rewriting  |
| mod_proxy   | Reverse proxy  |
| mod_headers | Header control |

---

# Apache Architecture

Apache architecture consists of:

* Core server
* Modules
* Processing models
* Configuration system

---

# Apache Directory Structure

```text id="1hcrlv"
/etc/apache2/
```

| Path            | Purpose             |
| --------------- | ------------------- |
| apache2.conf    | Main configuration  |
| ports.conf      | Port configuration  |
| sites-available | Site configurations |
| sites-enabled   | Active websites     |
| mods-available  | Available modules   |
| mods-enabled    | Enabled modules     |

---

# Apache MPM (Multi Processing Modules)

Apache supports multiple processing models:

### Prefork

* Process-based model

### Worker

* Thread-based model

### Event

* Modern asynchronous model

---

# 5. Nginx Web Server

Nginx is a modern high-performance web server widely used in cloud and DevOps environments.

---

# Features of Nginx

* Event-driven architecture
* High concurrency handling
* Reverse proxy support
* Load balancing
* Fast static file serving
* Low memory usage
* API gateway functionality

---

# Roles of Nginx

Nginx can act as:

* Web server
* Reverse proxy
* Load balancer
* Cache server
* API gateway

---

# Nginx Architecture

Nginx uses:

* Master-worker architecture

---

# Master Process Responsibilities

* Reads configuration
* Starts worker processes
* Manages workers

---

# Worker Process Responsibilities

* Handle client requests
* Serve content
* Proxy requests
* Manage connections

---

# Nginx Architecture Diagram

```text id="r0qkfi"
MASTER PROCESS
      │
 ┌────┼────┐
 │    │    │
W1   W2   WN
```

---

# Event-Driven Architecture

Nginx uses asynchronous non-blocking I/O.

This allows:

* One worker process
* Thousands of simultaneous connections

This is one major reason why Nginx performs better under heavy traffic.

---

# Nginx Request Processing Flow

```text id="e3u7dc"
Client Request
      ↓
Accept TCP Connection
      ↓
Worker Process
      ↓
Parse HTTP Request
      ↓
Select Server Block
      ↓
Select Location Block
      ↓
Send Response
```

---

# Nginx Configuration Hierarchy

```text id="v3mkh8"
Main
 ↓
Events
 ↓
HTTP
 ↓
Server
 ↓
Location
```

---

# Nginx Directory Structure

```text id="z1kz3t"
/etc/nginx/
```

| Path            | Purpose            |
| --------------- | ------------------ |
| nginx.conf      | Main configuration |
| sites-available | Available sites    |
| sites-enabled   | Active sites       |
| /var/www/html   | Default web root   |

---

# 6. Hosting a Static Website Using Nginx

---

# Steps Performed

1. Install Nginx
2. Create website directory
3. Add HTML files
4. Configure server block
5. Enable website
6. Restart Nginx service

---

# Example Nginx Configuration

```nginx id="srf0gx"
server {
    listen 80;
    server_name mysite.com;

    root /var/www/mysite;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

---

# 7. DNS Configuration

DNS converts:

* Domain names
* Into IP addresses

---

# DNS Flow

```text id="4znkg6"
Domain → DNS → IP Address → Web Server → Website
```

---

# Important DNS Records

| Record      | Purpose             |
| ----------- | ------------------- |
| A Record    | Maps domain to IPv4 |
| AAAA Record | Maps domain to IPv6 |
| CNAME       | Alias mapping       |

---

# 8. HTTP vs HTTPS

| Feature    | HTTP | HTTPS |
| ---------- | ---- | ----- |
| Security   | No   | Yes   |
| Encryption | No   | Yes   |
| Port       | 80   | 443   |

---

# Why HTTPS is Important

HTTPS provides:

* Secure communication
* Encryption
* Authentication
* Data integrity

Without HTTPS:

* Data can be intercepted
* Credentials can be stolen
* Communication becomes insecure

---

# 9. SSL/TLS Certificates

SSL/TLS certificates enable encrypted communication.

---

# TLS Handshake Process

```text id="8c3o2y"
Client Hello
      ↓
Server Certificate
      ↓
Key Exchange
      ↓
Secure Connection Established
```

---

# SSL/TLS Benefits

* Encryption
* Secure authentication
* Prevents data tampering
* Protects sensitive information

---

# SSL Setup Process

1. Install Certbot
2. Generate SSL certificate
3. Configure Nginx
4. Enable HTTPS
5. Configure auto-renewal

---

# Example HTTPS Configuration

```nginx id="8k0jha"
server {
    listen 443 ssl;
    server_name mysite.com;

    ssl_certificate /path/fullchain.pem;
    ssl_certificate_key /path/privkey.pem;
}
```

---

# 10. Reverse Proxy

A reverse proxy sits between clients and backend applications.

---

# Reverse Proxy Benefits

* Security
* Load balancing
* SSL termination
* Caching
* Traffic management

---

# Example Architecture

```text id="z3bpkt"
Client
   ↓
Nginx Reverse Proxy
   ↓
Application Server
```

---

# 11. Web Server vs Application Server

---

| Feature  | Web Server    | Application Server      |
| -------- | ------------- | ----------------------- |
| Role     | Serve content | Execute business logic  |
| Content  | Static        | Dynamic                 |
| Examples | Nginx, Apache | Node.js, Tomcat, Django |

---

# Real Production Request Flow

```text id="r07x0m"
Browser
   ↓
Web Server
   ↓
Application Server
   ↓
Database
   ↓
Response
```

---

# 12. Production Deployment Architecture

Modern production architecture contains multiple layers.

---

# Final Production Architecture

```text id="j1h6og"
User
  ↓
DNS
  ↓
Nginx Web Server
  ↓
Application Server
  ↓
Database Server
```

---

# 13. Load Balancing

Load balancing distributes incoming traffic across multiple servers.

---

# Advantages

* High availability
* Scalability
* Better performance
* Fault tolerance

---

# Nginx Load Balancer Example

```nginx id="l44m90"
upstream backend {
    server app1:3000;
    server app2:3000;
}
```

---

# 14. Logging and Monitoring

Web servers maintain logs for:

* Requests
* Errors
* Security events

---

# Common Log Files

## Nginx

```text id="s7u1db"
/var/log/nginx/access.log
/var/log/nginx/error.log
```

---

