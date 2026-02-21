# USER_DOC.md

# Inception — User Documentation

This document explains in clear and simple terms how to use and manage the Inception infrastructure.

---

# 1. Services Provided by the Stack

The project deploys a complete web infrastructure composed of multiple services running in Docker containers.

## 🌐 Web Services

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
- Available at: `http://localhost:8080`

### 4. Profile
- Static website
- Available at: `http://localhost:8081`

---

## 🗄 Database Services

### 5. MariaDB
- Database used by WordPress
- Data stored persistently on host

### 6. Adminer
- Web-based database management tool
- Allows database inspection and queries

---

## ⚡ Performance & Access

### 7. Redis
- Caching system for WordPress
- Improves performance

### 8. FTP
- Provides file access to WordPress files
- Port 21 + passive ports 30000–30009

---

## 📊 Monitoring & Management

### 9. Netdata
- Real-time monitoring dashboard
- Displays container and system metrics

### 10. Portainer
- Docker management interface
- Allows container and volume management

---

# 2. Starting and Stopping the Project

## 🔹 Start the Project

From the root of the project:

```bash
docker compose up --build
```

Run in background:

```bash
docker compose up -d --build
```

---

## 🔹 Stop the Project

```bash
docker compose down
```

---

## 🔹 Stop and Remove Volumes

⚠️ This will delete stored data (database + WordPress files):

```bash
docker compose down -v
```

---

# 3. Accessing the Website and Administration Panels

## 🌍 WordPress Website

```
https://localhost
```

(Uses HTTPS on port 443)

---

## ⚙ WordPress Admin Panel

```
https://localhost/wp-admin
```

Use credentials defined in `.env`.

---

## 🗄 Adminer (Database Management)

If exposed in your configuration:

```
http://localhost:<adminer_port>
```

Login with:
- System: MySQL
- Server: mariadb
- Username: value from `.env`
- Password: value from `.env`

---

## 📦 Portainer (Docker Management)

```
http://localhost:9000
```

First login requires creation of admin account.

---

## 📊 Netdata (Monitoring)

If exposed:

```
http://localhost:<netdata_port>
```

Displays system and container metrics.

---

## 💻 Vue App

```
http://localhost:8080
```

---

## 👤 Profile Site

```
http://localhost:8081
```

---

## 📁 FTP Access

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

## 🔐 How to Change Credentials

1. Edit the `.env` file.
2. Restart containers:

```bash
docker compose down
docker compose up -d --build
```

---

## 📂 Persistent Data Locations

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

## 🔎 Check Running Containers

```bash
docker ps
```

All services should show status: `Up`.

---

## 📋 Check Logs

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

## 🧪 Test Website

- Open `https://localhost`
- Ensure page loads correctly
- Login to `/wp-admin`

---

## 📊 Monitor with Netdata

- Check CPU, RAM usage
- Verify all containers are active

---

## 📦 Verify Network Connectivity

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