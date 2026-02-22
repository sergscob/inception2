# DEV_DOC.md

# Inception — Developer Documentation

This document explains how a developer can set up, build, run, and manage the Inception project from scratch.

---

# 1. Environment Setup from Scratch

## 1.1 Prerequisites

Before starting, ensure the following are installed:

- Docker 
- Docker Compose 

Check installation:

```bash
docker --version
docker compose version
make --version
```

If Docker is not installed:

Ubuntu:
```bash
sudo apk update
sudo apk install docker.io docker-compose-plugin
```

Enable Docker:

```bash
sudo systemctl enable docker
sudo systemctl start docker
```

(Optional) Allow running Docker without sudo:
```bash
sudo usermod -aG docker $USER
```
Then log out and log back in.

---

## 1.2 Clone the Repository

```bash
git clone <repository_url>
cd inception
```

---

## 1.3 Required Directory Structure

Persistent data is stored on the host machine using bind mounts.

Create required directories:

```bash
mkdir -p /home/sskobyak/data/db
mkdir -p /home/sskobyak/data/wp
```

Make sure permissions allow Docker to write into them.

---

## 1.4 Environment Configuration (.env)

The project uses a `.env` file for configuration and credentials.

Typical variables include:

- MYSQL_DATABASE
- MYSQL_USER
- MYSQL_PASSWORD
- MYSQL_ROOT_PASSWORD
- WORDPRESS_DB_NAME
- WORDPRESS_DB_USER
- WORDPRESS_DB_PASSWORD
- FTP_USER
- FTP_PASSWORD
- WP_ADMIN_USER=admin
- WP_ADMIN_PASSWORD=admin_pass
- WP_ADMIN_EMAIL=admin@example.com
# Optional second user
- WP_SECOND_USER=editor
- WP_SECOND_USER_PASSWORD=editor123
- WP_SECOND_USER_EMAIL=editor@example.com
# Telegram for site monitor (optional)
- TELEGRAM_TOKEN=<your_bot_token>
- TELEGRAM_CHAT_ID=<chat_id>


Steps:

1. Copy template (if available) or create `.env` manually.
2. Fill in all required values.
3. Keep this file private (do not commit secrets).

---

# 2. Building and Launching the Project

## 2.1 Using Makefile

If a Makefile is provided, common targets may include:

Builds and starts containers.

```bash
make all
```
→ Starts containers.

```bash
make down
```
→ Stops containers.

```bash
make clean
```
→ Stops containers and removes volumes.

(Adjust according to your actual Makefile implementation.)

---

## 2.2 Using Docker Compose Directly

Build and run:

```bash
docker compose up --build
```

Run in background:

```bash
docker compose up -d --build
```

Stop containers:

```bash
docker compose down
```

Stop and remove volumes:

```bash
docker compose down -v
```

---

# 3. Managing Containers and Volumes

## 3.1 List Running Containers

```bash
docker ps
```

List all containers:

```bash
docker ps -a
```

---

## 3.2 View Logs

```bash
docker logs <container_name>
```

Follow logs in real time:

```bash
docker logs -f <container_name>
```

---

## 3.3 Enter a Container

```bash
docker exec -it <container_name> sh
```

Example:

```bash
docker exec -it wordpress sh
```

---

## 3.4 Restart a Container

```bash
docker restart <container_name>
```

---

## 3.5 Manage Volumes

List volumes:

```bash
docker volume ls
```

Inspect volume:

```bash
docker volume inspect <volume_name>
```

Remove unused volumes:

```bash
docker volume prune
```

---

# 4. Data Storage and Persistence

## 4.1 Database Persistence

Service: MariaDB  
Volume: `db_data`  
Host path:

```
/home/sskobyak/data/db
```

All database files are stored here.  
Data persists even if containers are removed.

---

## 4.2 WordPress Persistence

Service: WordPress  
Volume: `wp_data`  
Host path:

```
/home/sskobyak/data/wp
```

Stores:

- Uploaded media
- Plugins
- Themes
- WordPress core files

---

# 5. Networking

All services are connected to a custom bridge network:

```
network:
  driver: bridge
```

This provides:

- Internal DNS resolution (service name = hostname)
- Isolation from host network
- Secure inter-container communication

Test internal connectivity:

```bash
docker exec -it wordpress ping mariadb
```

---

# 6. Rebuilding Specific Services

Rebuild only one service:

```bash
docker compose build wordpress
docker compose up -d wordpress
```

Rebuild everything without cache:

```bash
docker compose build --no-cache
```

---

# 7. Clean Reinstallation (Full Reset)

This removes all containers and persistent data.

```bash
docker compose down -v
sudo rm -rf /home/sskobyak/data/db/*
sudo rm -rf /home/sskobyak/data/wp/*
docker compose up -d --build
```

---

# 8. Development Workflow Tips

- Modify service configuration inside `srcs/<service>/`
- Rebuild only the modified service
- Use logs to debug startup errors
- Keep `.env` outside version control
- Avoid exposing unnecessary ports

---

# Summary

A developer can:

- Install Docker and prerequisites
- Configure environment variables
- Build and run the infrastructure
- Manage containers and volumes
- Inspect persistent data
- Fully reset and rebuild the system

This setup ensures a reproducible, isolated, and persistent multi-container environment suitable for development and testing.