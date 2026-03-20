FROM debian:bookworm

RUN apt-get update && apt-get install -y redis-server

COPY conf/redis.conf /etc/redis/redis.conf

EXPOSE 6379

ENTRYPOINT ["redis-server", "/etc/redis/redis.conf"]
#test docker exec wordpress wp redis status --allow-root