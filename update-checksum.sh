#!/usr/bin/env bash

# Renovate bumps ARG VERSION but cannot compute the tarball sha256, because
# TeamSpeak publishes no checksum for the alpine build.

set -o errexit
set -o nounset
set -o pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${root}"

version="$(sed -n 's/^ARG VERSION="\(.*\)"$/\1/p' Dockerfile)"
if test -z "${version}"; then
    echo "ARG VERSION not found in Dockerfile" >&2
    exit 1
fi

tmp="$(mktemp)"
trap 'rm -f "${tmp}"' EXIT

url="https://files.teamspeak-services.com/releases/server/${version}/teamspeak3-server_linux_alpine-${version}.tar.bz2"
echo "downloading ${url}" >&2
curl --fail --silent --show-error --location --output "${tmp}" "${url}"

checksum="$(sha256sum "${tmp}" | cut -d ' ' -f 1)"
sed -i "s/^ARG DOWNLOAD_CHECKSUM=.*/ARG DOWNLOAD_CHECKSUM=\"${checksum}\"/" Dockerfile
echo "${checksum}"
