# Developer Documentation

## Setting up from scratch

### Prerequisites

- Docker and Docker Compose installed
- Make installed
- A Linux/WSL environment

### Configuration

1. Clone the repository
2. Create `srcs/.env` with the following variables:

```env
DOMAIN_NAME=moel-amr.42.fr

MYSQL_DATABASE=wordpress
MYSQL_USER=your_db_user
MYSQL_PASSWORD=your_db_password
MYSQL_ROOT_PASSWORD=your_root_password

WP_TITLE=My Site
WP_ADMIN_USER=your_admin_user
WP_ADMIN_PASSWORD=your_admin_password
WP_ADMIN_EMAIL=admin@example.com
WP_USER=your_second_user
WP_USER_EMAIL=user@example.com
WP_USER_PASSWORD=your_user_password

WORDPRESS_DB_HOST=mariadb
WORDPRESS_DB_NAME=wordpress
WORDPRESS_DB_USER=your_db_user
WORDPRESS_DB_PASSWORD=your_db_password

FTP_USER=your_ftp_user
FTP_PASS=your_ftp_password
```

3. Add the domain to your hosts file:

```bash
echo "127.0.0.1 moel-amr.42.fr" | sudo tee -a /etc/hosts
```

On Windows (WSL), also add it to `C:\Windows\System32\drivers\etc\hosts`.

## Building and launching

```bash
make        # creates data dirs, builds images, starts containers
make build  # build only
make up     # start only (images must already be built)
make down   # stop containers
make logs   # follow logs
```

## Managing containers and volumes

```bash
# List running containers
sudo docker ps

# Check logs of a specific container
sudo docker logs <container_name>

# Execute a command inside a container
sudo docker exec -it <container_name> bash

# Stop and remove everything including volumes
make fclean

# Rebuild from scratch
make re
```

Useful debugging commands:

```bash
# Check WordPress Redis connection
sudo docker exec wordpress wp redis status --allow-root

# Check MariaDB
sudo docker exec -it mariadb mariadb -u root -p

# Check nginx config
sudo docker exec nginx nginx -t
```

## Data persistence

WordPress files and the MariaDB database are stored on the host machine at:

```
/home/moel-amr/data/mariadb/
/home/moel-amr/data/wordpress/
```

```bash
make fclean
```

This removes the containers, images, volumes, and the data directories. After this, `make` will reinstall WordPress and recreate the database from scratch.

## Project structure

```
.
├── Makefile
├── secrets/
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        ├── wordpress/
        │   ├── Dockerfile
        │   └── tools/
        └── bonus/
            ├── adminer/
            ├── ftp/
            ├── glances/
            ├── redis/
            └── static_site/
```