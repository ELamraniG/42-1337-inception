FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    vsftpd \
    && mkdir -p /var/run/vsftpd/empty \
    && rm -rf /var/lib/apt/lists/*

COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 21 50000-50010

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]