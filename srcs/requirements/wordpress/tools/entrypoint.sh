#!/bin/bash
set -e

echo "wait for maria"
while ! mysqladmin ping -h"${WORDPRESS_DB_HOST}" --silent 2>/dev/null; do
    echo "waiting for maria"
    sleep 2
done
echo "maria is good"


if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "wp not installed, installing"
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
fi

exec php-fpm8.2 -F
