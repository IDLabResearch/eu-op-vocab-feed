#!/bin/bash

# Source the environment variables
set -a
source ../conf.env
set +a

# Replace any environment variables in the files
  # Only replace targeted variables to avoid sed injection from other env vars
  for name in LDES_BASE_URL LDES_URL_PATH STORE_TYPE STORE_URL; do
      value="${!name}"
      # Escape | and & to prevent them from breaking sed
      value="${value//|/\\|}"
      value="${value//&/\\&}"
      sed -i "s|\${${name}}|${value}|g" ./config-ldes.json
  done

# Start the LDES server
npx @solid/community-server -c ./config-ldes.json -b ${LDES_BASE_URL}