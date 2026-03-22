*This project has been created as part of the 42 curriculum by moel-amr.*

# Inception

## Description

Inception is a system administration project from the 42 curriculum. The goal is to set up a small infrastructure using Docker and Docker Compose inside a virtual machine. Each service runs in its own container, built from scratch using custom Dockerfiles based on Debian Bookworm.

The stack includes a WordPress website served through Nginx with TLS, backed by MariaDB, with Redis for caching. Several bonus services are also included.

### Design Choices

**Virtual Machines vs Docker**
VMs virtualize an entire operating system with its own kernel, making them heavy and slow to start. Docker containers share the host kernel and only isolate the process, making them much lighter and faster. For this project, Docker is the right tool since we just want isolated services, not full OS environments.

**Secrets vs Environment Variables**
Environment variables are simple key-value pairs passed to containers at runtime. They're easy to use but can be exposed through `docker inspect` or logs. Docker secrets are more secure — they're stored encrypted and only mounted inside the container as files. For this project, .env files are used since it's a local development setup, but secrets would be the better choice in production.

**Docker Network vs Host Network**
Host network mode makes the container share the host's network stack directly — no isolation. Docker bridge network creates a private internal network where containers communicate by name. This project uses a custom bridge network called `inception` so containers can talk to each other securely without exposing unnecessary ports to the host.

**Docker Volumes vs Bind Mounts**
Bind mounts link a host directory directly into the container. Named volumes are managed by Docker and are more portable. This project uses named volumes with bind mount driver options so data is stored at `/home/moel-amr/data/` on the host, satisfying both the subject requirement and keeping data persistent across restarts.

## Instructions

### Requirements
- Docker
- Docker Compose
- Make

### Setup

Clone the repo and add the domain to your hosts file:

```bash
echo "127.0.0.1 moel-amr.42.fr" >> /etc/hosts
```

Create a `srcs/.env` file based on the required variables (see `.env.example` if provided).

### Run

```bash
make        # builds and starts everything
make down   # stops containers
make clean  # stops and removes containers/images
make fclean # full reset including volumes and data
make re     # full rebuild from scratch
make logs   # follow container logs
```

### Access

| Service | URL |
|---|---|
| WordPress | https://moel-amr.42.fr |
| Adminer | https://moel-amr.42.fr/adminer/ |
| Static Site | https://moel-amr.42.fr/static_site/ |
| Glances | http://localhost:61208 |
| FTP | ftp://localhost:21 |

## Resources

- [Docker documentation](https://docs.docker.com)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [Nginx documentation](https://nginx.org/en/docs/)
- [MariaDB documentation](https://mariadb.com/kb/en/)
- [WordPress WP-CLI](https://wp-cli.org/)
- [Redis Object Cache plugin](https://wordpress.org/plugins/redis-cache/)
- [Adminer](https://www.adminer.org/)
- [Glances](https://nicolargo.github.io/glances/)

### AI Usage

Claude (claude.ai) was used throughout this project to assist with debugging, understanding concepts, and generating configuration files. Specifically it helped with:
- Debugging MariaDB init scripts and WordPress entrypoint issues
- Understanding nginx proxy_pass, php-fpm configuration, and TLS setup
- Writing and fixing Docker Compose configuration
- Understanding Redis integration with WordPress
- Setting up bonus services (Adminer, Glances, FTP, static site)

All generated content was reviewed, tested, and understood before being used.