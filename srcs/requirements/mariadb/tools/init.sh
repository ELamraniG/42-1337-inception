#!/bin/bash
set -e
mysqld --skip-networking --skip-grant-tables --user=mysql &
MYSQLD_PID=$!

echo "Waiting for MariaDB to start..."
while ! mysqladmin ping --silent 2>/dev/null; do
    sleep 1
done

echo "Creating user and database..."
mysql -u root <<EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

wait $MYSQLD_PID

exec mysqld_safe --user=mysql