# USER_DOC.md

# Inception — User Documentation

This document explains in clear and simple terms how to use and manage the Inception infrastructure.

---

# 1. Services Provided by the Stack

The project deploys a complete web infrastructure composed of multiple services running in Docker containers.

## Web Services

### 1. NGINX
- Acts as the HTTPS entry point
- Listens on port **443**
- Serves the WordPress website

### 2. WordPress
- Main website (CMS)
- Stores content in a persistent volume
- Connected to MariaDB and Redis

### 3. VueApp
- Frontend application
- Available at: `https://vue.sskobyak.42.fr`

### 4. Profile
- Static website
- Available at: `https://profile.sskobyak.42.fr`

---

## Database Services

### 5. MariaDB
- Database used by WordPress
- Data stored persistently on host

### 6. Adminer
- Web-based database management tool
- Allows database inspection and queries

---

## Performance & Access

### 7. Redis
- Caching system for WordPress
- Improves performance

### 8. FTP
- Provides file access to WordPress files
- Port 21 + passive ports 30000–30009

---

## Monitoring & Management

### 9. Uptime Kuma
- Real-time monitoring dashboard
- Displays container and system metrics

### 10. Portainer
- Docker management interface
- Allows container and volume management

### 12. Monitoring script
- Checks website availability and sends alerts on Telegram


---

# 2. Starting and Stopping the Project

## Start the Project

From the root of the project:

```bash
make all
```

---

## Stop the Project

```bash
make down
```

---

## Stop and Remove Volumes

⚠️ This will delete stored data (database + WordPress files):

```bash
make clean
```

---

# 3. Accessing the Website and Administration Panels

## WordPress Website

```
https://sskobyak.42.fr
```
(Uses HTTPS on port 443)

---

## WordPress Admin Panel

```
https://sskobyak.42.fr/wp-admin
```

Use credentials defined in `.env`.

WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=admin_pass
WP_ADMIN_EMAIL=admin@example.com

WP_SECOND_USER=editor
WP_SECOND_USER_PASSWORD=editor123
WP_SECOND_USER_EMAIL=editor@example.com
WP_SECOND_USER_ROLE=editor

---

## Adminer (Database Management)

If exposed in your configuration:

```
https://sskobyak.42.fr/adminer
```

Login with:
- System: MySQL
- Server: mariadb
- Username: value from `.env`
- Password: value from `.env`

---

## 📦 Portainer (Docker Management)

```
https://sskobyak.42.fr/portainer
```

First login requires creation of admin account.

---

## Uptime Kuma (Monitoring)

```
https://uptime.sskobyak.42.fr
```

Displays system and container metrics.

---

## Vue App

```
https://vue.sskobyak.42.fr
```

---

## Profile Site

```
http://profile.sskobyak.42.fr
```

---

## FTP Access

- Host: localhost
- Port: 21
- Passive ports: 30000–30009
- Credentials: defined in `.env`

---

# 4. Locating and Managing Credentials

All credentials are stored in the `.env` file located at the root of the project.

Typical variables include:

- Database name
- Database user
- Database password
- WordPress admin user
- WordPress admin password
- FTP user
- FTP password

---

## How to Change Credentials

1. Edit the `.env` file.
2. Restart containers:

```bash
make re
```

---

## Persistent Data Locations

Database data:
```
/home/sskobyak/data/db
```

WordPress files:
```
/home/sskobyak/data/wp
```

You can inspect or back up these directories directly from the host.

---

# 5. Checking That Services Are Running Correctly

## Check Running Containers

```bash
docker ps
```

All services should show status: `Up`.

---

## Check Logs

View logs of a specific service:

```bash
docker logs <container_name>
```

Example:

```bash
docker logs wordpress
docker logs nginx
```

---

## Test Website

- Open `https://sskobyak.42.fr`
- Ensure page loads correctly
- Login to `/wp-admin`

---

## Verify Network Connectivity

Inside a container:

```bash
docker exec -it wordpress sh
ping mariadb
```

If ping works, internal networking is functional.

---

# 6. Troubleshooting

## Problem: Website not loading
- Check `docker ps`
- Check `docker logs nginx`
- Verify port 443 is not used by another service

## Problem: WordPress cannot connect to database
- Check `docker logs wordpress`
- Ensure MariaDB container is running
- Verify database credentials in `.env`

## Problem: Changes not reflected
- Restart containers
- Clear browser cache

---

# Summary

This stack provides:

- Secure HTTPS WordPress website
- Database management
- File access via FTP
- Performance optimization with Redis
- Monitoring with Netdata
- Container management with Portainer
- Additional frontend applications

All services are isolated, containerized, and managed through Docker Compose.