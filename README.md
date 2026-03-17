*This project has been created as part of the 42 curriculum by moel-amr.*

## Description
This project builds a small Docker-based infrastructure with three mandatory services: NGINX (TLS only), WordPress with PHP-FPM, and MariaDB. Each service runs in its own container and communicates through an isolated Docker network.

The stack goal is to provide a secure local website entrypoint over HTTPS (`DOMAIN_NAME`) while persisting both database and website data across container restarts.

### Docker usage and project sources
- Orchestration is defined in `srcs/docker-compose.yml`.
- Service images are built from custom Dockerfiles in `srcs/requirements/*`.
- Runtime configuration is provided via `srcs/.env`.
- Data persists through named Docker volumes mapped under `/home/roote/data`.

### Main design choices
- NGINX is the only public entrypoint on port 443.
- WordPress runs only PHP-FPM and does not include NGINX.
- MariaDB runs as a dedicated database service.
- Domain and TLS certificate CN are generated from environment variables at container start.

### Comparison notes
#### Virtual Machines vs Docker
- VMs virtualize full operating systems and are heavier.
- Docker virtualizes at process level, starts faster, and is easier to reproduce with Compose.

#### Secrets vs Environment Variables
- Environment variables are simple and convenient for local setup.
- Docker secrets are safer for sensitive values and reduce accidental disclosure.

#### Docker Network vs Host Network
- Docker bridge network isolates services and allows internal DNS (`mariadb`, `wordpress`).
- Host network removes isolation and is not suitable for this project constraints.

#### Docker Volumes vs Bind Mounts
- Named volumes provide managed persistence decoupled from container lifecycle.
- Bind mounts map explicit host paths and are useful when a fixed host location is required.

## Instructions
### Prerequisites
- Docker Engine with Compose plugin installed.
- `make` installed.
- Domain from `srcs/.env` mapped to local machine (for example in `/etc/hosts`).

### Build and run
```bash
make
```

### Stop
```bash
make down
```

### Full cleanup
```bash
make fclean
```

## Resources
- Docker documentation: https://docs.docker.com/
- Docker Compose specification: https://docs.docker.com/compose/
- NGINX documentation: https://nginx.org/en/docs/
- MariaDB documentation: https://mariadb.com/kb/en/documentation/
- WordPress CLI documentation: https://developer.wordpress.org/cli/commands/

### AI usage
