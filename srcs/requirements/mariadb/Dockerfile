FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server \
    && mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld \
    && rm -f /etc/mysql/mariadb.conf.d/50-server.cnf

COPY conf/my.cnf /etc/mysql/conf.d/my.cnf
COPY tools/init.sh /init.sh
RUN chmod 755 /init.sh && chmod 644 /etc/mysql/conf.d/my.cnf

ENTRYPOINT ["/init.sh"]