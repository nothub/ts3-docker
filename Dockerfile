FROM alpine:3

RUN apk add --no-cache \
    ca-certificates    \
    libpq              \
    libstdc++          \
    su-exec            \
    tini

ARG VERSION="3.13.8"
ARG DOWNLOAD_CHECKSUM="b04af5fbcbca3e847336389569eca3bff6339cba6f13f0151d6b012360e038ae"
ARG DOWNLOAD_URL="https://files.teamspeak-services.com/releases/server/${VERSION}/teamspeak3-server_linux_alpine-${VERSION}.tar.bz2"

ENV PUID=1000
ENV PGID=1000

ENV TS3SERVER_LICENSE=view
ENV QUERY_CLIENT=""

ADD ${DOWNLOAD_URL} /tmp/server.tar.bz2

RUN echo "${DOWNLOAD_CHECKSUM}  /tmp/server.tar.bz2" | sha256sum -c -        \
    && mkdir -p /opt/ts3                                                     \
    && tar xvf /tmp/server.tar.bz2 --directory=/opt/ts3 --strip-components 1 \
    && rm -f /tmp/server.tar.bz2

COPY entrypoint.sh /entrypoint.sh

VOLUME /data

EXPOSE 9987/udp 10011 10022 10080 10443 30033 41144

ENTRYPOINT ["/sbin/tini", "-vv", "--", "/entrypoint.sh"]
