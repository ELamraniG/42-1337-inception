#!/bin/bash
set -e

echo "waiting for mariadb"
while ! mysqladmin ping -P3306 -h"${WORDPRESS_DB_HOST}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}"; do
    sleep 2
done

if [ ! -f "/var/www/html/wp-config.php" ]; then
    wp core download --allow-root --path="/var/www/html"

    wp config create --allow-root \
        --dbname="${WORDPRESS_DB_NAME}" \
        --dbuser="${WORDPRESS_DB_USER}" \
        --dbpass="${WORDPRESS_DB_PASSWORD}" \
        --dbhost="${WORDPRESS_DB_HOST}"

    wp core install --allow-root \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}"

    wp user create --allow-root \
        "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=editor

    wp plugin install redis-cache --activate --allow-root
    wp config set WP_REDIS_HOST redis --type=constant --allow-root
    wp config set WP_REDIS_PORT 6379 --raw --type=constant --allow-root
    wp redis enable --allow-root
fi

exec php-fpm8.2 -F