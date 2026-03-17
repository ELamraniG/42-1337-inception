# USER_DOC

## Provided services
- `nginx`: HTTPS entrypoint (port 443) with TLS.
- `wordpress`: PHP-FPM application service.
- `mariadb`: database service for WordPress.

## Start and stop
### Start
```bash
make
```

### Stop
```bash
make down
```

### Restart from scratch
```bash
make re
```

## Access website and admin panel
- Website: `https://moel-amr.42.fr`
- WordPress admin: `https://moel-amr.42.fr/wp-admin`

If the domain does not resolve locally, add it in `/etc/hosts`:
```text
127.0.0.1 moel-amr.42.fr
```

## Credentials management
- Runtime configuration is stored in `srcs/.env`.
- WordPress administrator credentials are defined with:
  - `WP_ADMIN_USER`
  - `WP_ADMIN_PASSWORD`
  - `WP_ADMIN_EMAIL`
- Database credentials are defined with:
  - `MYSQL_*`
  - `WORDPRESS_DB_*`

## Verify services are running
```bash
docker compose -f srcs/docker-compose.yml ps
```

### Check logs
```bash
make logs
```

### Quick health checks
- HTTPS endpoint returns content:
```bash
curl -kI https://moel-amr.42.fr
```
- Containers are up:
```bash
docker ps
```