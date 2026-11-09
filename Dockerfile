FROM debian:bookworm-slim

LABEL maintainer="CORTEX contributors"

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /opt/cortex

COPY . /opt/cortex

# install.sh does the real apt work; run it with --yes-equivalent by piping y
RUN apt-get update && \
    apt-get install -y python3 sudo && \
    chmod +x install.sh cortex.py && \
    yes y | ./install.sh || true && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["python3", "cortex.py"]
