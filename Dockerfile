FROM ubuntu:24.04

# Install prerequisites
RUN apt-get update && \
    apt-get install -y fortune-mod cowsay netcat-openbsd && \
    rm -rf /var/lib/apt/lists/*

# Add to path since cowsay/fortune are typically in /usr/games
ENV PATH="/usr/games:${PATH}"

WORKDIR /app

COPY wisecow.sh /app/wisecow.sh
RUN chmod +x /app/wisecow.sh

# The script default port is 4499
EXPOSE 4499

ENTRYPOINT ["/app/wisecow.sh"]
