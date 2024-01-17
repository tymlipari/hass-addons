#!/command/with-contenv bashio
# shellcheck shell=bash

# Parse config options

export CONFIG_PATH=/data/options.json

DOMAIN_NAME=$(bashio::config 'domain_name')
RECORD_NAME=$(bashio::config 'record_name')
API_KEY=$(bashio::config 'godaddy_api_key')
API_SECRET=$(bashio::config 'godaddy_api_secret')

# Run forever (or until we get killed)
while true; do
  echo "Checking for DNS updates"
  ./update_godaddy_record.sh \
      --domain="$DOMAIN_NAME" \
      --record="$RECORD_NAME" \
      --api-key="$API_KEY" \
      --api-secret="$API_SECRET"

  echo "Waiting 10 minutes until next check"
  sleep 10m
done