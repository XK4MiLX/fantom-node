#!/usr/bin/env ash

set -e

# download the genesis file
if [ -f "/root/genesis/${FANTOM_GENESIS}" ]; then
  echo "💼 found ${FANTOM_GENESIS}"
else
  mkdir -p /root/genesis
  echo "🌐 downloading genesis file ${FANTOM_GENESIS}"
  wget "https://download.fantom.network/${FANTOM_GENESIS}" -O "/root/genesis/${FANTOM_GENESIS}"
  echo "💼 using genesis file ${FANTOM_GENESIS}"
fi

if [ "" = "$*" ] || [ "run.sh" = "$*" ]; then
  echo "🦄 Starting Fantom Opera"
  exec "run.sh"
else
  echo "🦄 Starting '$@'"
  exec "$@"
fi
