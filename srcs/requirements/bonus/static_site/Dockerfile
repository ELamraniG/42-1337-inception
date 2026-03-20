FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /var/www/static_site/index.html

EXPOSE 8080

ENTRYPOINT ["nginx", "-g", "daemon off;"]