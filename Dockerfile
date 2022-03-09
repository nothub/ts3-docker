FROM alpine:3

RUN apk add --no-cache \
    ca-certificates    \
    libpq              \
    libstdc++          \
    su-exec            \
    tini

ARG DOWNLOAD_URL=https://files.teamspeak-services.com/releases/server/3.13.6/teamspeak3-server_linux_alpine-3.13.6.tar.bz2
ARG DOWNLOAD_CHECKSUM=f30a5366f12b0c5b00476652ebc06d9b5bc4754c4cb386c086758cceb620a8d0

ENV TS3SERVER_LICENSE=view

ENV PUID=1000
ENV PGID=1000

ADD ${DOWNLOAD_URL} /tmp/server.tar.bz2

RUN echo "${DOWNLOAD_CHECKSUM}  /tmp/server.tar.bz2" | sha256sum -c -        \
    && mkdir -p /opt/ts3                                                     \
    && tar xvf /tmp/server.tar.bz2 --directory=/opt/ts3 --strip-components 1 \
    && rm -f /tmp/server.tar.bz2

COPY entrypoint.sh /entrypoint.sh

VOLUME /data

EXPOSE 9987/udp 10011 10022 10080 10443 30033 41144

ENTRYPOINT ["/sbin/tini", "-vv", "--", "/entrypoint.sh"]
