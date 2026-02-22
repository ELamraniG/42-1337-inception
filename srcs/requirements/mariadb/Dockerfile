FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server
#not sure about copying the mysql conf part
COPY conf/my.cnf /etc/mysql/conf.d/my.cnf
COPY tools/init.sh /init.sh

RUN chmod +x /init.sh

EXPOSE 3306

ENTRYPOINT ["/init.sh"]