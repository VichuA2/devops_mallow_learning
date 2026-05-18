# Week 4 – Networking Fundamentals, OSI/TCP-IP, DNS, HTTP & Protocols

# 1. Networking Fundamentals

## What is Networking?

Networking is the process of connecting multiple computers or devices together to exchange data and resources.

The Internet itself is a very large network made up of millions of interconnected systems.

---

## Goals of Networking

* Device communication
* File and resource sharing
* Internet access
* Remote system management
* Application communication
* Distributed computing

---

# 2. Types of Networks
## Types of Networks

Networks are classified based on geographical coverage, communication range, and usage purpose.

---

# 1. PAN – Personal Area Network

PAN is a very small network used for personal devices within a short range.

### Features

* Very short distance communication
* Low power consumption
* Mostly wireless
* Used for personal device connectivity

### Examples

* Bluetooth headset connection
* Mobile hotspot
* Smartwatch connected to phone
* Wireless keyboard and mouse

### Range

Usually within 10 meters.

---

# 2. LAN – Local Area Network

LAN covers a small geographical area such as a room, building, office, or campus.

### Features

* High speed communication
* Low latency
* Privately managed
* Easy resource sharing

### Examples

* Home WiFi network
* Office network
* Computer laboratory
* School campus network

### Devices Used

* Switch
* Router
* Access Point

---

# 3. CAN – Campus Area Network

CAN connects multiple LANs within a limited campus or organization.

### Features

* Larger than LAN
* High-speed internal communication
* Centralized management

### Examples

* University campus network
* Corporate office buildings
* Hospital campus network

---

# 4. MAN – Metropolitan Area Network

MAN covers an entire city or metropolitan area.

### Features

* Connects multiple LANs or CANs
* Medium to high speed
* Used by telecom providers and large organizations

### Examples

* City-wide fiber network
* Government office connectivity
* Internet service provider backbone within a city

---

# 5. WAN – Wide Area Network

WAN covers very large geographical regions including countries and continents.

### Features

* Long-distance communication
* Connects multiple MANs and LANs
* Uses leased lines, fiber, satellite communication

### Examples

* The Internet
* International banking network
* Global enterprise network

### Advantages

* Worldwide connectivity
* Remote access
* Cloud communication support

---

# Comparison Table

| Network Type | Full Form                 | Coverage Area              | Example             |
| ------------ | ------------------------- | -------------------------- | ------------------- |
| PAN          | Personal Area Network     | Few meters                 | Bluetooth           |
| LAN          | Local Area Network        | Building                   | Office WiFi         |
| CAN          | Campus Area Network       | Campus                     | University          |
| MAN          | Metropolitan Area Network | City                       | Metro fiber network |
| WAN          | Wide Area Network         | Country/Global             | Internet            |

---

# 3. Networking Components

---

# IP Address

An IP Address (Internet Protocol Address) is a unique numerical identifier assigned to every device connected to a network.
It helps devices communicate and exchange data over networks and the Internet.

Examples of devices using IP addresses:

* Computers
* Mobile phones
* Servers
* Routers
* Printers
* Cloud instances

---

# Types of IP Addresses

IP addresses are mainly divided into:

1. IPv4
2. IPv6

---

# 1. IPv4 – Internet Protocol Version 4

IPv4 is the most widely used IP addressing system.

It uses:

* 32-bit addressing
* Four decimal numbers separated by dots

### Example

```text id="lt8e6n"
192.168.1.10
```

---

## IPv4 Structure

IPv4 contains 4 octets.

Example:

```text id="ys0gxh"
192 . 168 . 1 . 10
```

Each octet ranges from:

* 0 to 255

---

## IPv4 Features

* 32-bit address
* Supports approximately 4.3 billion addresses
* Easy to understand
* Widely used across networks

---

## IPv4 Types

### Public IP

Accessible over the Internet.

### Private IP

Used inside local networks.

Private IP ranges:

```text id="3q5kz9"
10.0.0.0 – 10.255.255.255
172.16.0.0 – 172.31.255.255
192.168.0.0 – 192.168.255.255
```

---

## IPv4 Limitations

* Limited number of addresses
* Address exhaustion problem
* Requires NAT for large-scale usage

---

# 2. IPv6 – Internet Protocol Version 6

IPv6 was introduced to overcome IPv4 address limitations.

It uses:

* 128-bit addressing
* Hexadecimal representation

---

## IPv6 Example

```text id="smd7zt"
2001:0db8:85a3:0000:0000:8a2e:0370:7334
```

---

## IPv6 Features

* Huge address space
* Better security support
* Improved routing efficiency
* No NAT requirement in most cases
* Supports modern Internet growth

---

## IPv6 Characteristics

* Written in hexadecimal
* Uses colon (:) separators
* Supports trillions of unique addresses

---

# IPv4 vs IPv6

| Feature          | IPv4         | IPv6                   |
| ---------------- | ------------ | ---------------------- |
| Address Size     | 32-bit       | 128-bit                |
| Format           | Decimal      | Hexadecimal            |
| Example          | 192.168.1.1  | 2001:db8::1            |
| Address Capacity | ~4.3 Billion | Extremely Large        |
| NAT Required     | Yes          | Usually No             |
| Security         | Optional     | Built-in IPsec support |

---

# Why IPv6 is Important

With the growth of:

* Cloud computing
* IoT devices
* Mobile devices
* Smart devices
* Internet services

IPv4 addresses became insufficient.

IPv6 provides enough addresses for future Internet expansion.

---

# Real-Time Usage

## IPv4 Common Usage

* Home networks
* Office networks
* Existing enterprise systems

---

## IPv6 Common Usage

* Modern cloud infrastructure
* Telecom networks
* Large-scale Internet providers
* IoT ecosystems

---

## MAC Address

A MAC address uniquely identifies the physical network hardware.

It operates at:

* Data Link Layer

---

## Router

A router connects multiple networks together.

### Functions

* Packet forwarding
* Routing
* Internet connectivity

---

## Switch

A switch connects devices inside the same LAN.

### Functions

* MAC address learning
* Internal communication

---

## Modem

A modem connects the local network to the ISP.

---

# 4. OSI Model

The OSI model divides networking into 7 layers.

---

| Layer        | Function                  |
| ------------ | ------------------------- |
| Application  | User services             |
| Presentation | Encryption and formatting |
| Session      | Session management        |
| Transport    | Reliable communication    |
| Network      | Routing                   |
| Data Link    | MAC addressing            |
| Physical     | Signal transmission       |

---

# 5. TCP/IP Model

TCP/IP is the practical networking model used on the Internet.

---

| Layer          | Example Protocols |
| -------------- | ----------------- |
| Application    | HTTP, DNS, SMTP   |
| Transport      | TCP, UDP          |
| Internet       | IP, ICMP          |
| Network Access | Ethernet          |

---

# 6. OSI vs TCP/IP

| OSI               | TCP/IP                |
| ----------------- | --------------------- |
| 7 Layers          | 4 Layers              |
| Theoretical model | Practical model       |
| Used for learning | Used in real networks |

---

# 7. IP Addressing

IP addresses identify systems in a network.

---

## Types of IP Addresses

### Public IP

Accessible over the Internet.

### Private IP

Used inside internal networks.

---

## IPv4

32-bit addressing format.

### Example

```text id="9l4t4o"
192.168.1.1
```

---

## IPv6

128-bit addressing format.

Created to solve IPv4 exhaustion.

---

# 8. DNS – Domain Name System

DNS converts human-readable domain names into IP addresses.

---

## Example

```text id="ywjlwm"
google.com → 142.x.x.x
```

---

# 9. DNS Resolution Flow

When a user opens a website:

1. Browser checks local cache
2. OS resolver checks cache
3. Recursive DNS server queried
4. Root DNS server contacted
5. TLD server contacted
6. Authoritative server returns IP
7. Browser receives IP address

---

# 10. DNS Port

DNS mainly uses:

```text id="nqtejy"
Port 53
```

* UDP for normal queries
* TCP for larger responses

---

# 11. HTTP Protocol

HTTP stands for:

* HyperText Transfer Protocol

Used for communication between browsers and web servers.

---

# 12. HTTP Request Structure

Example request:

```http id="if5a4e"
GET /index.html HTTP/1.1
Host: example.com
```

---

## HTTP Request Components

* Method
* Path
* HTTP version
* Headers
* Body

---

# 13. HTTP Methods

| Method | Purpose         |
| ------ | --------------- |
| GET    | Retrieve data   |
| POST   | Send data       |
| PUT    | Update resource |
| DELETE | Remove resource |

---

# 14. HTTP Response Structure

Example:

```http id="yj0vtm"
HTTP/1.1 200 OK
Content-Type: text/html
```

---

# 15. HTTP Status Codes

---

## 2xx – Success

| Code | Meaning |
| ---- | ------- |
| 200  | OK      |
| 201  | Created |

---

## 3xx – Redirection

| Code | Meaning           |
| ---- | ----------------- |
| 301  | Moved Permanently |

---

## 4xx – Client Errors

| Code | Meaning     |
| ---- | ----------- |
| 400  | Bad Request |
| 404  | Not Found   |

---

## 5xx – Server Errors

| Code | Meaning               |
| ---- | --------------------- |
| 500  | Internal Server Error |

---

# 16. HTTPS

HTTPS is:

* HTTP + TLS Encryption

---

## HTTPS Port

```text id="fzw6k6"
443
```

---

## Benefits

* Encryption
* Authentication
* Data integrity
* Secure communication

---

# 17. HTTP Headers

Headers contain metadata.

---

## Request Headers

| Header        | Purpose             |
| ------------- | ------------------- |
| Host          | Requested domain    |
| User-Agent    | Browser information |
| Accept        | Supported formats   |
| Authorization | Authentication      |
| Cookie        | Session information |

---

## Response Headers

| Header         | Purpose                |
| -------------- | ---------------------- |
| Content-Type   | Response format        |
| Content-Length | Data size              |
| Server         | Web server information |
| Set-Cookie     | Session creation       |
| Cache-Control  | Caching rules          |

---

# 18. Network Protocols and Ports

Protocols define communication rules.

Ports identify applications.

---

| Protocol | Port   | Purpose         |
| -------- | ------ | --------------- |
| HTTP     | 80     | Web traffic     |
| HTTPS    | 443    | Secure web      |
| DNS      | 53     | Name resolution |
| SSH      | 22     | Remote login    |
| FTP      | 21     | File transfer   |
| SMTP     | 25/587 | Sending emails  |
| IMAP     | 143    | Email retrieval |
| POP3     | 110    | Email download  |
| DHCP     | 67/68  | IP assignment   |

---

# 19. TCP vs UDP

| Feature     | TCP                 | UDP            |
| ----------- | ------------------- | -------------- |
| Reliability | Yes                 | No             |
| Speed       | Slower              | Faster         |
| Connection  | Connection-oriented | Connectionless |

---

## TCP Use Cases

* Websites
* SSH
* Databases

---

## UDP Use Cases

* Streaming
* Gaming
* DNS

---

# 20. TCP 3-Way Handshake

TCP establishes connection using:

1. SYN
2. SYN-ACK
3. ACK

This ensures reliable communication.

---

# 21. Packet Encapsulation

At every layer, additional headers are added.

---

## Encapsulation Flow

```text id="krv9v8"
Ethernet Frame
    ↓
IP Packet
    ↓
TCP Segment
    ↓
HTTP Data
```

---

# 22. Real Website Access Flow

When a user opens a website:

1. URL entered in browser
2. DNS lookup performed
3. ARP resolves MAC address
4. TCP handshake starts
5. TLS encryption established
6. HTTP request sent
7. Routers forward packets
8. Server processes request
9. Response returned
10. Browser renders webpage

---

# 23. Linux Networking Commands

---

## ping

Checks connectivity.

```bash id="h7m1p3"
ping google.com
```

---

## curl

Tests HTTP responses.

```bash id="8b19qx"
curl -I https://example.com
```

---

## ss

Checks listening ports.

```bash id="jrcjpw"
ss -tuln
```

---

## traceroute

Tracks packet path.

```bash id="qdf5i4"
traceroute google.com
```

---

# 24. Troubleshooting Concepts

---

## Website Not Loading

Possible issues:

* DNS failure
* HTTP server down
* Firewall issue

---

## SSH Connection Failure

Possible causes:

* Port 22 blocked
* Security group issue
* SSH service stopped

---

## No IP Address

Possible cause:

* DHCP failure

---

## Slow Website

Possible causes:

* Large responses
* High latency
* Caching issues

---

# 25. Protocol Stack Example

Opening a website involves:

```text id="gm0k5y"
Application → HTTP
Security → TLS
Transport → TCP
Network → IP
Data Link → Ethernet
```

