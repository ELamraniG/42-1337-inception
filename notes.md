# Inception 42 Project - Complete Learning Guide

## Project Overview
Build a multi-container Docker application with:
- **Nginx** (Web server + HTTPS)
- **MariaDB** (Database)
- **WordPress** (PHP CMS)

All services communicate via Docker network and persist data with volumes.

---

## Phase 1: Docker Fundamentals (Days 1-2)

### 1.1 Core Concepts
- [ ] Understand images vs containers
- [ ] Learn Dockerfile syntax (FROM, RUN, COPY, EXPOSE, CMD, ENTRYPOINT)
- [ ] Understand Docker volumes (data persistence)
- [ ] Understand Docker networks (container communication)
- [ ] Learn environment variables in Docker

**Key Commands to Know:**
```bash
docker ps                           # List running containers
docker images                       # List images
docker build -t name .              # Build image
docker run -d -p 80:80 image        # Run container
docker logs container_name          # View logs
docker exec -it container_name bash # Enter container
docker stop container_name          # Stop container
docker rm container_name            # Delete container
```

### 1.2 Docker Compose Basics
- [ ] Understand docker-compose.yml structure
- [ ] Learn service definitions
- [ ] Understand volumes in compose
- [ ] Understand networks in compose
- [ ] Learn environment variable passing

**Key Commands:**
```bash
docker-compose build                # Build all services
docker-compose up -d                # Start services (detached)
docker-compose down                 # Stop and remove services
docker-compose ps                   # List services
docker-compose logs -f              # Follow logs
docker-compose exec service bash    # Execute command in service
```

---

## Phase 2: MariaDB Setup (Days 3-4)

### 2.1 MariaDB Basics
- [ ] Understand relational databases
- [ ] Learn MariaDB vs MySQL differences
- [ ] Understand database initialization scripts
- [ ] Learn about MariaDB configuration files

### 2.2 MariaDB Dockerfile
**What to include:**
```
FROM mariadb:latest
EXPOSE 3306
COPY conf/ /etc/mysql/conf.d/          # Config files
COPY tools/ /docker-entrypoint-initdb.d/  # Init scripts
CMD ["mysqld"]
```

### 2.3 Create MariaDB Configuration
- [ ] Create `srcs/requirements/mariadb/conf/my.cnf`
   - Set bind address (0.0.0.0 for Docker)
   - Set default storage engine
   - Enable binary logging (optional)

### 2.4 Create MariaDB Init Script
- [ ] Create `srcs/requirements/mariadb/tools/init.sql`
   - Create database
   - Create database user
   - Grant privileges
   - Example:
     ```sql
     CREATE DATABASE IF NOT EXISTS wordpress;
     CREATE USER 'wordpress_user'@'%' IDENTIFIED BY 'password';
     GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress_user'@'%';
     FLUSH PRIVILEGES;
     ```

### 2.5 Test MariaDB Container
```bash
make build
make up
docker-compose exec mariadb mariadb -u root -p wordpress
SHOW TABLES;
EXIT;
```

---

## Phase 3: WordPress Setup (Days 5-6)

### 3.1 WordPress Basics
- [ ] Understand what WordPress needs (PHP, MySQL client)
- [ ] Learn WordPress configuration (wp-config.php)
- [ ] Understand WordPress database schema
- [ ] Learn WP-CLI (WordPress command line tool)

### 3.2 WordPress Dockerfile
**What to include:**
```
FROM php:8.1-fpm
WORKDIR /var/www/html
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libzip-dev
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd mysqli zip
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
EXPOSE 9000
CMD ["php-fpm"]
```

### 3.3 Create WordPress Entrypoint Script
- [ ] Create `srcs/requirements/wordpress/tools/entrypoint.sh`
   - Wait for MariaDB to be ready (retry loop)
   - Download WordPress if not exists
   - Create wp-config.php with environment variables
   - Run wp-cli commands to set up site
   - Start PHP-FPM

**Example setup flow:**
```bash
#!/bin/bash
# Wait for database
while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" 2>/dev/null; do
  sleep 1
done

# Download WordPress
wp core download --allow-root

# Create config
wp config create --allow-root \
  --dbname=$WORDPRESS_DB_NAME \
  --dbuser=$WORDPRESS_DB_USER \
  --dbpass=$WORDPRESS_DB_PASSWORD \
  --dbhost=$WORDPRESS_DB_HOST

# Install WordPress
wp core install --allow-root \
  --url=$DOMAIN_NAME \
  --title=$WP_TITLE \
  --admin_user=$WP_ADMIN_USER \
  --admin_password=$WP_ADMIN_PASSWORD \
  --admin_email=$WP_ADMIN_EMAIL

# Start PHP-FPM
php-fpm
```

### 3.4 Test WordPress
```bash
docker-compose logs wordpress
docker-compose exec wordpress wp --allow-root user list
```

---

## Phase 4: Nginx Setup (Days 7-8)

### 4.1 Nginx Basics
- [ ] Understand reverse proxy concept
- [ ] Learn Nginx server blocks (virtual hosts)
- [ ] Understand SSL/TLS certificates
- [ ] Learn about FastCGI (PHP communication)

### 4.2 Generate SSL Certificate
```bash
# Create self-signed certificate for testing
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout private.key -out certificate.crt \
  -subj "/C=FR/ST=France/L=Paris/O=42/CN=wil.42.fr"
```

### 4.3 Nginx Dockerfile
```
FROM nginx:alpine
COPY conf/ /etc/nginx/conf.d/
COPY tools/ /docker-entrypoint.d/
COPY ssl/ /etc/nginx/ssl/
EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]
```

### 4.4 Create Nginx Configuration
- [ ] Create `srcs/requirements/nginx/conf/nginx.conf`
   - Listen on 443 (HTTPS)
   - SSL certificate paths
   - Proxy requests to WordPress (php-fpm)
   - Set server name to DOMAIN_NAME

**Key directives:**
```nginx
server {
    listen 443 ssl;
    server_name wil.42.fr;
    
    ssl_certificate /etc/nginx/ssl/certificate.crt;
    ssl_certificate_key /etc/nginx/ssl/private.key;
    
    root /var/www/html;
    index index.php index.html;
    
    location ~ \.php$ {
        fastcgi_pass wordpress:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```

### 4.5 Test Nginx
```bash
docker-compose logs nginx
# Visit https://wil.42.fr in browser (ignore certificate warning)
```

---

## Phase 5: Docker Compose Integration (Days 9-10)

### 5.1 Update docker-compose.yml
- [ ] Ensure all three services defined
- [ ] Set up volumes for persistence
- [ ] Configure networks
- [ ] Set environment variables
- [ ] Set restart policies
- [ ] Set dependencies (depends_on)

**Check:**
```yaml
services:
  mariadb:
    build: ./requirements/mariadb
    environment: [from .env]
    volumes: [persistent storage]
    networks: [inception]
    
  wordpress:
    build: ./requirements/wordpress
    depends_on: [mariadb]
    environment: [database connection]
    volumes: [/var/www/html]
    networks: [inception]
    
  nginx:
    build: ./requirements/nginx
    depends_on: [wordpress]
    ports: [443:443]
    volumes: [wordpress data from volume]
    networks: [inception]

volumes:
  mariadb_data:
  wordpress_data:

networks:
  inception:
    driver: bridge
```

### 5.2 Test Full Stack
```bash
make clean          # Clean everything
make build          # Build all images
make up             # Start all services
make logs           # Watch logs
```

### 5.3 Health Check
- [ ] Open https://wil.42.fr
- [ ] Check WordPress installation wizard
- [ ] Verify database connection
- [ ] Check SSL certificate

---

## Phase 6: Advanced Features (Days 11-12)

### 6.1 Health Checks
- [ ] Add healthcheck to each service
- [ ] Verify containers auto-restart on failure

```yaml
healthcheck:
  test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
  interval: 10s
  timeout: 5s
  retries: 5
```

### 6.2 Logging & Debugging
- [ ] Learn to read Docker logs
- [ ] Use docker inspect to view configuration
- [ ] Debug network connectivity between containers
- [ ] Check volumes and mounted paths

**Useful commands:**
```bash
docker inspect container_name     # See full config
docker network ls                 # List networks
docker volume ls                  # List volumes
docker-compose exec service env   # View service environment
```

### 6.3 Bonus Features (Optional)
- [ ] **Redis** for caching
- [ ] **FTP Server** for file uploads
- [ ] **Adminer** for database GUI
- [ ] **Portainer** for container management
- [ ] Create additional WordPress users via wp-cli

---

## Phase 7: Security & Best Practices (Days 13-14)

### 7.1 Secrets Management
- [ ] Never hardcode passwords
- [ ] Use .env file for development
- [ ] Add .gitignore to prevent leaks
- [ ] Use strong, random passwords

### 7.2 Dockerfile Best Practices
- [ ] Use specific version tags (not 'latest')
- [ ] Minimize layers (combine RUN commands)
- [ ] Use .dockerignore to exclude unnecessary files
- [ ] Non-root user (best practice, not required here)

### 7.3 Network Security
- [ ] Only expose necessary ports (443 for Nginx)
- [ ] Use internal network for service-to-service communication
- [ ] Validate SSL certificate (or generate proper one)

### 7.4 Database Security
- [ ] Use strong root password
- [ ] Limit user privileges (don't use root for app)
- [ ] Restrict user host ('%' only for Docker)
- [ ] Enable binary logging for backup

---

## Phase 8: Troubleshooting & Testing (Days 15-16)

### 8.1 Common Issues & Solutions

**MariaDB Won't Start**
```bash
docker-compose logs mariadb
# Check: port conflict, volume permission, init script syntax
```

**WordPress Can't Connect to Database**
```bash
docker-compose exec wordpress ping mariadb
dns: check container can resolve mariadb hostname
# Check: hostname, port, credentials in environment
```

**Nginx 502 Bad Gateway**
```bash
docker-compose logs nginx
# Check: PHP-FPM port, socket path, fastcgi_pass configuration
```

**SSL Certificate Errors**
```bash
# Regenerate certificate with correct domain
# Or install custom certificate
```

### 8.2 Testing Checklist
- [ ] All containers running: `docker-compose ps`
- [ ] All services healthy: Check logs
- [ ] WordPress loads: https://wil.42.fr
- [ ] Database persists: data survives docker-compose down/up
- [ ] Make commands work: `make build`, `make up`, `make down`
- [ ] Clean rebuild: `make fclean && make all`

### 8.3 Performance & Cleanup
```bash
make clean    # Remove stopped containers
make fclean   # Remove images too
docker system prune -a  # Aggressive cleanup
```

---

## Phase 9: Final Touches (Days 17-18)

### 9.1 Documentation
- [ ] Document how to run the project (README.md)
- [ ] Document environment variables needed
- [ ] Document port mappings
- [ ] Document troubleshooting steps

### 9.2 Code Quality
- [ ] Review all Dockerfiles for efficiency
- [ ] Check configuration files for security
- [ ] Verify .gitignore prevents secret leaks
- [ ] Clean up temporary files

### 9.3 Project Submission
- [ ] Test everything works from clean clone
- [ ] Verify Makefile targets: build, up, down, clean, fclean, re
- [ ] Check logs command works
- [ ] Ensure .git is present (git push successful)

---

## Quick Reference: File Structure

```
inception/
├── Makefile                           # Docker Compose shortcuts
├── .gitignore                         # Protect .env and secrets
├── srcs/
│   ├── .env                           # Environment variables (NEVER COMMIT)
│   ├── docker-compose.yml             # Container orchestration
│   └── requirements/
│       ├── mariadb/
│       │   ├── Dockerfile
│       │   ├── .dockerignore
│       │   ├── conf/
│       │   │   └── my.cnf            # MariaDB config
│       │   └── tools/
│       │       └── init.sql          # Database setup
│       ├── wordpress/
│       │   ├── Dockerfile
│       │   ├── .dockerignore
│       │   └── tools/
│       │       └── entrypoint.sh     # WordPress setup & start
│       └── nginx/
│           ├── Dockerfile
│           ├── .dockerignore
│           ├── conf/
│           │   └── nginx.conf        # Nginx configuration
│           ├── tools/
│           └── ssl/
│               ├── certificate.crt   # SSL certificate
│               └── private.key       # SSL private key
```

---

## Timeline Summary

| Phase | Days | Focus |
|-------|------|-------|
| 1. Docker Fundamentals | 1-2 | Learn Docker basics and commands |
| 2. MariaDB | 3-4 | Database container & initialization |
| 3. WordPress | 5-6 | PHP-FPM container & setup scripts |
| 4. Nginx | 7-8 | Web server, reverse proxy, SSL |
| 5. Integration | 9-10 | Docker Compose orchestration |
| 6. Advanced | 11-12 | Health checks, logging, bonus features |
| 7. Security | 13-14 | Best practices and hardening |
| 8. Testing | 15-16 | Troubleshooting and validation |
| 9. Submission | 17-18 | Final cleanup and documentation |

---

## Essential Commands Cheat Sheet

```bash
# Build & Run
make build              # Build all images
make up                 # Start all services
make down               # Stop all services
make logs               # View all logs

# Quick Docker checks
docker-compose ps      # Which containers running?
docker-compose logs service_name -f  # Follow specific service logs

# Debug
docker-compose exec mariadb mariadb -u root -p wordpress
docker-compose exec wordpress wp --allow-root user list
docker exec -it nginx ash

# Clean
make clean              # Light cleanup
make fclean             # Full cleanup including images
```

---

## Resources to Explore

- Docker Documentation: https://docs.docker.com/
- MariaDB Documentation: https://mariadb.com/docs/
- Nginx Documentation: https://nginx.org/en/docs/
- WordPress Documentation: https://wordpress.org/support/
- Docker Compose Reference: https://docs.docker.com/compose/compose-file/

---

## Notes

- Start with ONE service working before adding others
- Test incrementally, don't build all 3 at once
- Save your working docker-compose.yml before trying changes
- Use `docker system prune` when stuck (nuclear option)
- Read error logs carefully - they tell you what's wrong
- Don't be afraid to restart containers: `docker-compose restart service_name`

Good luck! 🚀
