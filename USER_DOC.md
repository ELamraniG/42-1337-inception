# User Documentation

## What services are running?

| Service | Description |
|---|---|
| Nginx | The only entry point. Handles HTTPS on port 443 and proxies to other services |
| WordPress | The main website with php-fpm |
| MariaDB | The database for WordPress |
| Redis | Cache for WordPress to speed things up |
| Adminer | Web-based database management UI |
| Static Site | A simple personal showcase site |
| FTP | File access to the WordPress volume |
| Glances | System monitoring dashboard |

## Starting and stopping the project

Start everything:
```bash
make
```

Stop everything (keeps data):
```bash
make down
```

Full reset (deletes all data):
```bash
make fclean
```

## Accessing the services

Make sure you have this line in your hosts file (`/etc/hosts` on Linux/Mac, `C:\Windows\System32\drivers\etc\hosts` on Windows):

```
127.0.0.1 moel-amr.42.fr
```

Then:

- **WordPress site**: https://moel-amr.42.fr
- **WordPress admin panel**: https://moel-amr.42.fr/wp-admin
- **Adminer**: https://moel-amr.42.fr/adminer/
- **Static site**: https://moel-amr.42.fr/static_site/
- **Glances**: http://localhost:61208
- **FTP**: connect to localhost on port 21

The SSL certificate is self-signed so your browser will show a warning — just accept it and continue.

## Credentials

All credentials are stored in `srcs/.env`. This file is not committed to git for security reasons. Ask the project owner for the credentials or check the file directly on the machine.

For Adminer, use:
- **Server**: mariadb
- **Username** and **Password**: from your `.env` file

## Checking that services are running

```bash
sudo docker ps
```

All containers should show `Up` status. If one is not running:

```bash
sudo docker logs <container_name>
```

To check Redis is working with WordPress:

```bash
sudo docker exec wordpress wp redis status --allow-root
```

Should show `Status: Connected`.