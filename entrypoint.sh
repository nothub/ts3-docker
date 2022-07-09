#!/usr/bin/env sh

set -eux

addgroup                                                   \
    --gid "${PGID}"        `#Group id`                     \
    --system               `#Create a system group`        \
    teamspeak

adduser                                                    \
    --uid "${PUID}"        `#User id`                      \
    --system               `#Create a system user`         \
    --ingroup teamspeak    `#Add user to existing group`   \
    --disabled-password    `#Do not assign a password`     \
    --no-create-home       `#Do not create home directory` \
    teamspeak

chown -R teamspeak:teamspeak /data

cd /data

# explicit whitelisting is needed because the server uses a very strict rate
# limiting system that does not use 429 or headers but just stops responding...
if [ -z "${QUERY_CLIENT}" ]; then QUERY_CLIENT="$(/sbin/ip route | awk '/default/ { print $3 }')"; fi
if ! grep "${QUERY_CLIENT}" /data/query_ip_allowlist.txt >/dev/null 2>&1; then
    echo >&2 "unrestricted query access for: ${QUERY_CLIENT}"
    echo "${QUERY_CLIENT}" >>/data/query_ip_allowlist.txt
fi

exec su-exec teamspeak:teamspeak /opt/ts3/ts3server dbsqlpath=/opt/ts3/sql/ "$@"
