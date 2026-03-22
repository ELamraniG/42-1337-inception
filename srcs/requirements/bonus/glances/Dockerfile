FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends python3-pip \
    && pip3 install --no-cache-dir --break-system-packages "glances[web]==3.4.0" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 61208

ENTRYPOINT ["glances", "-w"]