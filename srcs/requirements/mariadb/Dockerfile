FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server \
    && mkdir -p /run/mysqld && chown -R mysql /run/mysqld

COPY conf/my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init.sh /init.sh
RUN chmod 755 /init.sh && chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf

ENTRYPOINT ["/init.sh"]