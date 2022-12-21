#!/usr/bin/env bash
set -e
# start opera with genesis file
echo "🦄 Settings: API=${FANTOM_API}"
opera \
  --http \
  --http.addr=0.0.0.0 \
  --http.api="${FANTOM_API}" \
  --http.port=18545 \
  --http.corsdomain="*" \
  --http.vhosts="*" \
  --verbosity="${FANTOM_VERBOSITY}" \
  --cache="${FANTOM_CACHE}" \
  --genesis="/root/genesis/${FANTOM_GENESIS}"
