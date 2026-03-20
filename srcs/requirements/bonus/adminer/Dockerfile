FROM debian:bookworm

RUN apt-get update && apt-get install -y php php-mysqli curl

RUN curl -L https://www.adminer.org/latest.php -o /var/www/html/index.php

EXPOSE 8080

ENTRYPOINT ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]