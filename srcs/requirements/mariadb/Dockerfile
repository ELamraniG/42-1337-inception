FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server
COPY conf/my.cnf /etc/mysql/conf.d/my.cnf
COPY tools/init.sh /init.sh


EXPOSE 3306

ENTRYPOINT ["/init.sh"]