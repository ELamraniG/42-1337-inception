# DEV_DOC

## Environment setup from scratch
### Prerequisites
- Linux host with Docker Engine and Docker Compose plugin.
- `make` utility.
- Sudo rights for Docker and host path creation.

### Required configuration files
- Compose file: `srcs/docker-compose.yml`
- Environment file: `srcs/.env`
- Service Dockerfiles:
  - `srcs/requirements/nginx/Dockerfile`
  - `srcs/requirements/wordpress/Dockerfile`
  - `srcs/requirements/mariadb/Dockerfile`

### Domain setup
Add your domain to local resolver (`/etc/hosts`), example:
```text
127.0.0.1 moel-amr.42.fr
```

## Build and launch flow
### Build images
```bash
make build
```

### Start containers
```bash
make up
```

### Build + start
```bash
make
```

## Management commands
### Inspect status
```bash
docker compose -f srcs/docker-compose.yml ps
```

### Follow logs
```bash
make logs
```

### Stop stack
```bash
make down
```

### Cleanup
```bash
make clean
make fclean
```

## Data storage and persistence
Persistent data is stored with named volumes:
- `mariadb_data` -> `/var/lib/mysql`
- `wordpress_data` -> `/var/www/html`

Host persistence location:
- `/home/roote/data/mariadb`
- `/home/roote/data/wordpress`

Containers can be removed and recreated without losing data as long as these volume mappings are preserved.

## Secrets and credentials notes
- Current setup uses environment variables from `srcs/.env`.
- For stronger security, move sensitive values to Docker secrets and keep secret files outside Git tracking.