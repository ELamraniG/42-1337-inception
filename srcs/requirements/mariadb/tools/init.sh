#!/bin/bash

#if any command fails , exit
    set -e

# mysqld but safe automaticall restart if fail
# no connection outside of the contaniner can connect for now
mysqld_safe --skip-networking &


echo "wait"
#add --silent 2>/dev/null later 
#we ping the database until we get a reponse to make sure its on
while ! mysqladmin ping -u root; do
    sleep 1
done

echo "creating user and database"
mysql -u root <<lopo
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
lopo

# 4. Shut down the temp instance
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

echo "finished with success"

# 5. Start MariaDB for real (as main process)
exec mysqld_safe