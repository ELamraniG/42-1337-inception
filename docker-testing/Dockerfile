FROM debian:latest
RUN apt-get update && apt-get install -y gcc

COPY . . 
RUN gcc c.c -o main
ENTRYPOINT ["ls"]
# 