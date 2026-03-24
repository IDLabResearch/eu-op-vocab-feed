#!/bin/bash

# Clean up temporary run files
rm -f ./config-ldes-run.json

# Source the environment variables
set -a
source ../conf.env
set +a

# Create temporary run files from templates
cp ./config-ldes.json ./config-ldes-run.json

# Replace any environment variables in the files
  # Only replace targeted variables to avoid sed injection from other env vars
  for name in LDES_BASE_URL LDES_URL_PATH STORE_TYPE STORE_URL; do
      value="${!name}"
      # Escape | and & to prevent them from breaking sed
      value="${value//|/\\|}"
      value="${value//&/\\&}"
      sed -i "s|\${${name}}|${value}|g" ./config-ldes-run.json
  done

# Start the LDES server
npx @solid/community-server -c ./config-ldes-run.json -b ${LDES_BASE_URL}