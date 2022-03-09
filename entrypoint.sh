#!/usr/bin/env sh

set -eux

addgroup                                                     \
      --gid "${PGID}"        `#Group id`                     \
      --system               `#Create a system group`        \
      teamspeak

adduser                                                      \
      --uid "${PUID}"        `#User id`                      \
      --system               `#Create a system user`         \
      --ingroup teamspeak    `#Add user to existing group`   \
      --disabled-password    `#Do not assign a password`     \
      --no-create-home       `#Do not create home directory` \
      teamspeak

chown -R teamspeak:teamspeak /data

cd /data

exec su-exec teamspeak:teamspeak /opt/ts3/ts3server dbsqlpath=/opt/ts3/sql/ "$@"
