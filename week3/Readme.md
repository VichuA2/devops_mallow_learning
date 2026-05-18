# Week 3 – Shell Scripting, Linux Commands, Supervisor & Monit

## Introduction

During Week 3, I focused on learning Linux shell scripting, process management, monitoring tools, and practical Linux administration commands.
This week helped me understand how automation works in Linux environments and how system administrators monitor and manage running services.

I practiced:

* Bash scripting
* Conditional statements
* Loops
* Linux administration commands
* Supervisor process manager
* Monit monitoring tool
* Log analysis
* Service management
* Automation scripting

The complete practice notes and examples were prepared based on the training exercises. 

---

# 1. Shell Scripting Basics

Shell scripting is used to automate repetitive Linux tasks.

A shell script usually starts with:

```bash
#!/bin/bash
```

This line is called:

* Shebang
* Hashbang

It tells Linux to execute the script using the Bash interpreter.

---

# 2. Numeric Comparison Operators

Numeric comparison operators are used to compare integer values.

| Operator | Meaning               |
| -------- | --------------------- |
| `-eq`    | Equal                 |
| `-ne`    | Not Equal             |
| `-gt`    | Greater Than          |
| `-lt`    | Less Than             |
| `-ge`    | Greater Than or Equal |
| `-le`    | Less Than or Equal    |

---

## Example Script

```bash
#!/bin/bash

a=10
b=20

if [ $a -eq $b ]; then
    echo "a is equal to b"
fi

if [ $a -ne $b ]; then
    echo "a is not equal to b"
fi

if [ $a -gt $b ]; then
    echo "a is greater than b"
else
    echo "a is not greater than b"
fi

if [ $a -lt $b ]; then
    echo "a is less than b"
fi
```

---

# 3. String Comparison Operators

String operators are used to compare text values.

| Operator | Meaning      |
| -------- | ------------ |
| `=`      | Equal        |
| `!=`     | Not Equal    |
| `-z`     | Empty String |
| `-n`     | Not Empty    |

---

## Example

```bash
#!/bin/bash

str1="hello"
str2="world"

if [ "$str1" != "$str2" ]; then
    echo "Strings are different"
fi
```

---

# 4. String Manipulation

Linux Bash provides string formatting features.

| Syntax     | Description             |
| ---------- | ----------------------- |
| `${VAR^^}` | Convert to uppercase    |
| `${VAR,,}` | Convert to lowercase    |
| `${VAR^}`  | Capitalize first letter |

---

## Example

```bash
#!/bin/bash

VAR="hello world"

echo ${VAR^^}
echo ${VAR,,}
echo ${VAR^}
```

---

# 5. Logical Operators

Logical operators combine multiple conditions.

| Operator | Description |   |    |
| -------- | ----------- | - | -- |
| `&&`     | AND         |   |    |
| `        |             | ` | OR |
| `!`      | NOT         |   |    |

---

## Example

```bash
#!/bin/bash

age=20
id="yes"

if [[ $age -ge 18 && "$id" == "yes" ]]; then
    echo "Access granted"
fi
```

---

# 6. Conditional Statements

Conditional statements are used to make decisions inside scripts.

---

## If Statement

```bash
if [ condition ]
then
    commands
fi
```

---

## If Else Example

```bash
#!/bin/bash

num=5

if [ $num -gt 10 ]
then
    echo "Greater"
else
    echo "Smaller"
fi
```

---

## If Elif Else Example

```bash
#!/bin/bash

num=10

if [ $num -gt 10 ]
then
    echo "Greater"

elif [ $num -eq 10 ]
then
    echo "Equal"

else
    echo "Smaller"
fi
```

---

# 7. Loops

Loops are used to execute commands repeatedly.

---

## 7.1 For Loop

```bash
for i in 1 2 3 4 5
do
    echo $i
done
```

---

## 7.2 While Loop

```bash
i=1

while [ $i -le 5 ]
do
    echo $i
    ((i++))
done
```

---

## 7.3 Until Loop

```bash
i=1

until [ $i -gt 5 ]
do
    echo $i
    ((i++))
done
```

---

# 8. Loop Control Statements

---

## break

Stops the loop completely.

```bash
for i in {1..10}
do
    if [ $i -eq 5 ]; then
        break
    fi

    echo $i
done
```

---

## continue

Skips one iteration.

```bash
for i in {1..5}
do
    if [ $i -eq 3 ]; then
        continue
    fi

    echo $i
done
```

---

# 9. File Test Operators

File test operators check files and directories.

| Operator | Meaning          |
| -------- | ---------------- |
| `-f`     | File exists      |
| `-d`     | Directory exists |
| `-r`     | Readable         |
| `-w`     | Writable         |
| `-x`     | Executable       |

---

## Example

```bash
#!/bin/bash

if [ -f "test.txt" ]
then
    echo "File exists"
else
    echo "File not found"
fi
```

---

# 10. Important Linux Commands

---

## grep

Used for searching text.

```bash
grep "ERROR" app.log
grep -i "error" app.log
grep -n "ERROR" app.log
```

---

## awk

Used for data extraction and formatting.

```bash
df -h | awk '{print $1,$5}'
```

---

## sed

Used for editing text streams.

```bash
sed 's/error/ERROR/g' file.txt
```

---

## cut

Extract columns from files.

```bash
cut -d':' -f1 /etc/passwd
```

---

## sort

Sort file contents.

```bash
sort file.txt
```

---

## uniq

Remove duplicate lines.

```bash
sort file.txt | uniq
```

---

## wc

Count lines, words, and characters.

```bash
wc -l file.txt
wc -w file.txt
wc -c file.txt
```

---

## head and tail

```bash
head file.txt
tail file.txt
tail -f app.log
```

---

# 11. Practical Shell Scripting Tasks

---

## Count Lines, Words, Characters

```bash
#!/bin/bash

file=$1

echo "Lines: $(wc -l < $file)"
echo "Words: $(wc -w < $file)"
echo "Characters: $(wc -c < $file)"
```

---

## Log File Processing

```bash
#!/bin/bash

logfile="app.log"

grep "ERROR" $logfile
grep "WARNING" $logfile
```

---

## System Information Script

```bash
#!/bin/bash

uname -r
free -h
ps aux | head
```

---

# 12. Supervisor

Supervisor is a process management tool used to manage long-running applications.

It helps:

* Start applications
* Stop applications
* Restart applications
* Auto restart failed services

---

## Supervisor Installation

```bash
sudo apt update
sudo apt install supervisor
```

---

## Create Dummy Script

```bash
nano ~/ticktock.sh
```

---

## Script

```bash
#!/bin/bash

while true
do
    echo "Tick $(date)"
    sleep 1
done
```

---

## Supervisor Configuration

```bash
sudo nano /etc/supervisor/conf.d/ticktock.conf
```

---

## Configuration Content

```ini
[program:ticktock]
command=/home/user/ticktock.sh
autostart=true
autorestart=true
stdout_logfile=/var/log/ticktock.out.log
stderr_logfile=/var/log/ticktock.err.log
```

---

## Supervisor Commands

```bash
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl status
sudo supervisorctl restart ticktock
```

---

# 13. Monit

Monit is a monitoring tool used to monitor:

* CPU
* Memory
* Disk usage
* Services
* Processes

---

## Monit Installation

```bash
sudo apt install monit -y
```

---

## Important Commands

```bash
monit --version
sudo monit reload
sudo monit status
sudo systemctl status monit
```

---

## Monit Configuration Files

Main directory:

```bash
/etc/monit
```

Important files:

* monitrc
* conf-enabled
* conf-available
* conf.d

---

# 14. Enable Monit Web UI

```bash
set httpd port 2812 and
    use address 0.0.0.0
    allow admin:monit
```

---

## Access Monit

```bash
http://localhost:2812
```

---

# 15. Monitoring Examples

---

## Check Nginx Service

```bash
#!/bin/bash

if pgrep nginx > /dev/null
then
    echo "Nginx Running"
else
    echo "Nginx Stopped"
fi
```

---

## Disk Usage Monitoring

```bash
#!/bin/bash

usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ $usage -gt 80 ]
then
    echo "Disk usage high"
else
    echo "Disk usage normal"
fi
```

---
