FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends python3-pip \
    && pip3 install --no-cache-dir --ignore-installed --break-system-packages "glances[web]" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 61208

ENTRYPOINT ["glances", "-w"]