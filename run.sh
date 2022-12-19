#!/usr/bin/env sh

# start opera with genesis file
echo "starting fantom opera"

set -e

opera \
  --http \
  --http.addr "0.0.0.0" \
  --http.api "${FANTOM_API}" \
  --http.corsdomain "*" \
  --http.vhosts "*"\
  --verbosity "${FANTOM_VERBOSITY}" \
  --cache "${FANTOM_CACHE}" \
  --genesis "/root/genesis/${FANTOM_GENESIS}"
