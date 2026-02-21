*This project has been created as part of the 42 curriculum by sskobyak.*

# Inception

## Description

**Inception** is a DevOps-oriented infrastructure project built with Docker and Docker Compose.  
The goal is to deploy a complete, containerized web ecosystem composed of multiple interconnected services, each running in its own isolated container.

The infrastructure includes:

- NGINX (HTTPS reverse proxy)
- WordPress (PHP-FPM)
- MariaDB (database)
- FTP server
- Redis (cache)
- Adminer (database management)
- Vue.js application
- Profile static site
- Netdata (monitoring)
- Portainer (Docker management UI)

All services are connected via a custom Docker bridge network and built from custom Dockerfiles (except Portainer).

---

## Architecture Overview

### Core Web Stack

- **NGINX**
  - Only public HTTPS entry point (443)
  - Serves WordPress content
  - Uses shared volume with WordPress

- **WordPress**
  - Connected to MariaDB
  - Uses Redis for caching
  - Persistent storage via `wp_data` volume

- **MariaDB**
  - Database backend for WordPress
  - Persistent storage via `db_data` volume

---

### Additional Services

- **FTP**
  - Provides file access to WordPress volume
  - Passive ports: 30000–30009

- **Redis**
  - Improves WordPress performance

- **Adminer**
  - Lightweight DB management interface

- **VueApp**
  - Frontend app available at `http://localhost:8080`

- **Profile**
  - Static site available at `http://localhost:8081`

- **Netdata**
  - Real-time monitoring
  - Access to Docker metrics
  - Uses dedicated volumes for configuration and cache

- **Portainer**
  - Docker container management UI
  - Available at `http://localhost:9000`

---

## Project Structure

```
.
├── docker-compose.yml
├── .env
├── srcs/
│   ├── mariadb/
│   ├── wordpress/
│   ├── nginx/
│   ├── ftp/
│   ├── redis/
│   ├── adminer/
│   ├── vueapp/
│   ├── profile/
│   └── netdata/
└── README.md
```

Each service has its own `Dockerfile` and configuration inside `srcs/`.

---

## Design Choices

### Virtual Machines vs Docker

| Virtual Machines | Docker |
|------------------|--------|
| Full OS per VM | Shared host kernel |
| Heavy resource usage | Lightweight |
| Slower startup | Fast container startup |
| Hardware-level virtualization | Process-level isolation |

**Chosen:** Docker — due to efficiency, lightweight nature, and modern DevOps practices.

---

### Secrets vs Environment Variables

| Environment Variables | Docker Secrets |
|-----------------------|----------------|
| Easy to configure | More secure |
| Visible in container metadata | Hidden from inspect |
| Suitable for development | Suitable for production |

In this project, credentials are managed via `.env` file.  
In production environments, Docker Secrets would be preferable for improved security.

---

### Docker Network vs Host Network

| Bridge Network | Host Network |
|----------------|-------------|
| Isolated | Shares host stack |
| Container name resolution | No isolation |
| More secure | Less secure |

A custom bridge network is used to:
- Isolate services
- Enable internal DNS resolution
- Prevent unnecessary host exposure

---

### Docker Volumes vs Bind Mounts

| Docker Volumes | Bind Mounts |
|---------------|------------|
| Managed by Docker | Direct host mapping |
| Portable | Host-dependent |
| Cleaner abstraction | Easier manual access |

This project uses bind mounts for persistent data:

- `/home/sskobyak/data/db`
- `/home/sskobyak/data/wp`

This allows:
- Full control over stored data
- Easy inspection from host system

---

## Instructions

### Requirements

- Docker
- Docker Compose (v2+ recommended)

Check installation:

```bash
docker --version
docker compose version
```

---

### Setup

1. Clone repository:

```bash
git clone <repository_url>
cd inception
```

2. Create required data directories:

```bash
mkdir -p /home/sskobyak/data/db
mkdir -p /home/sskobyak/data/wp
```

3. Configure environment variables in `.env`

---

### Build & Run

```bash
docker compose up --build
```

Run in background:

```bash
docker compose up -d --build
```

---

## Access Points

| Service | URL |
|----------|------|
| WordPress (HTTPS) | https://localhost |
| Vue App | http://localhost:8080 |
| Profile Site | http://localhost:8081 |
| Portainer | http://localhost:9000 |
| FTP | port 21 |

---

## Security Notes

- Only HTTPS (443) exposed for main website
- Database not exposed to host
- All services communicate internally via Docker network
- Monitoring containers use read-only mounts where applicable

---

## Resources

- Docker Documentation – https://docs.docker.com/
- Docker Compose Documentation – https://docs.docker.com/compose/
- NGINX Documentation – https://nginx.org/en/docs/
- MariaDB Documentation – https://mariadb.org/documentation/
- WordPress Documentation – https://wordpress.org/support/
- Redis Documentation – https://redis.io/documentation
- Netdata Documentation – https://learn.netdata.cloud/
- Portainer Documentation – https://docs.portainer.io/

---

## How AI Was Used

AI tools were used for:

- Clarifying Docker networking concepts
- Understanding Redis integration with WordPress
- Reviewing configuration structure
- Comparing Docker vs VM architecture
- Improving documentation structure and clarity

All container configurations, debugging, and integration were implemented and tested manually.

---

## Conclusion

This project demonstrates:

- Multi-container orchestration
- Secure service separation
- Persistent data management
- Monitoring and container administration
- Practical DevOps skills

Inception simulates a production-like containerized infrastructure using modern container technologies.