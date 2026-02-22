*This project has been created as part of the 42 curriculum by sskobyak.*

# Inception

## Description

**Inception** is a DevOps-oriented infrastructure project built with Docker and Docker Compose.  
The goal is to deploy a complete, containerized web ecosystem composed of multiple interconnected services, each running in its own isolated container.

The infrastructure includes:

- **NGINX** (HTTPS reverse proxy)
- **WordPress** (PHP-FPM) with admin and secondary user
- **MariaDB** (database)
- **FTP server**
- **Redis** (cache)
- **Adminer** (database management)
- **Vue.js application**
- **Profile static site**
- **Portainer** (Docker management UI)
- **Site Monitor** (checks website availability and sends alerts on Telegram)

All services are connected via a custom Docker bridge network and built from custom Dockerfiles.

---

## Architecture Overview

### Core Web Stack

- **NGINX**
  - Public HTTPS entry point (443)
  - Serves WordPress content and routes other services
  - Shared volume with WordPress

- **WordPress**
  - Connected to MariaDB
  - Uses Redis for object caching
  - Persistent storage via `wp_data` volume
  - Supports two users (admin and secondary)  

- **MariaDB**
  - Database backend for WordPress
  - Persistent storage via `db_data` volume

---

### Additional Services

- **FTP**
  - Provides file access to WordPress volume
  - Passive ports: 30000–30009

- **Redis**
  - Improves WordPress performance via object caching

- **Adminer**
  - Lightweight DB management interface
  - Available at `https://sskobyak.42.fr/adminer/`

- **VueApp**
  - Frontend application available at `https://vue.sskobyak.42.fr`

- **Profile**
  - Static site available at `https://profile.sskobyak.42.fr`

- **Portainer**
  - Docker container management UI
  - Available at `https://sskobyak.42.fr/portainer/`

- **Site Monitor**
  - Monitors availability of configured websites
  - Sends alerts via Telegram 

---

## Project Structure

```
.
├── docker-compose.yml
├── .env
├── srcs/
│ ├── mariadb/
│ ├── wordpress/
│ ├── nginx/
│ ├── ftp/
│ ├── redis/
│ ├── adminer/
│ ├── vueapp/
│ ├── profile/
│ ├── site_monitor/
│ └── portainer/
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

In this project, credentials for WordPress secondary user can be managed via `.env`.  

---

### Docker Network vs Host Network

| Bridge Network | Host Network |
|----------------|-------------|
| Isolated | Shares host stack |
| Container name resolution | No isolation |
| More secure | Less secure |

A custom bridge network isolates services and enables internal DNS resolution.

---

### Docker Volumes vs Bind Mounts

| Docker Volumes | Bind Mounts |
|---------------|------------|
| Managed by Docker | Direct host mapping |
| Portable | Host-dependent |
| Cleaner abstraction | Easier manual access |

Bind mounts are used for persistent data:

- `/home/sskobyak/data/db` — MariaDB database
- `/home/sskobyak/data/wp` — WordPress files

---

## Instructions

### Requirements

- Docker
- Docker Compose

Check installation:

```bash
docker --version
docker compose version
```

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

MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_DATABASE=wordpress
MYSQL_USER=wordpress_user
MYSQL_PASSWORD=your_password

WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=admin_pass
WP_ADMIN_EMAIL=admin@example.com

# Optional second user
WP_SECOND_USER=editor
WP_SECOND_USER_PASSWORD=editor123
WP_SECOND_USER_EMAIL=editor@example.com
WP_SECOND_USER_ROLE=editor

# Telegram for site monitor (optional)
TELEGRAM_TOKEN=<your_bot_token>
TELEGRAM_CHAT_ID=<chat_id>

---

### Build & Run

```bash
make all
```

---

## Access Points

| Service           | URL / Port                                                                    |
| ----------------- | ----------------------------------------------------------------------------- |
| WordPress (HTTPS) | [https://sskobyak.42.fr/](https://sskobyak.42.fr/)                            |
| Vue App           | [https://vue.sskobyak.42.fr/](https://vuesskobyak.42.fr/)                     |
| Profile Site      | [https://profile.sskobyak.42.fr/](https://profile.sskobyak.42.fr/)            |
| Portainer         | [https://sskobyak.42.fr/portainer](https://sskobyak.42.fr/portainer)          |
| FTP               | port 21                                                                       |
| Adminer           | [https://sskobyak.42.fr/adminer/](https://sskobyak.42.fr/adminer)             |

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