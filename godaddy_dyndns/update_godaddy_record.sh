#!/usr/bin/env bash
# Adapted from https://www.instructables.com/Quick-and-Dirty-Dynamic-DNS-Using-GoDaddy/

set -oue pipefail

# Global args
DOMAIN_NAME=
RECORD_NAME=
API_KEY=
API_SECRET=

function retrieve_godaddy_ip {
  local api_data
  api_data=$(curl -s -X GET -H "Authorization: sso-key ${API_KEY}:${API_SECRET}" \
      "https://api.godaddy.com/v1/domains/${DOMAIN_NAME}/records/A/${RECORD_NAME}")

  if [[ -z $api_data || "$(echo "$api_data" | jq '. | length')" -eq 0 ]]; then
    echo "Failed to get data for A record ${RECORD_NAME}.${DOMAIN_NAME}" >/dev/stderr
    exit 1
  elif [[ "$(echo "$api_data" | jq '.[0] | has("code")')" = "true" ]]; then
    echo "An error occurred: $api_data" >/dev/stderr
    exit 1
  elif [[ "$(echo "$api_data" | jq '.[0] | has("data")')" != "true" ]]; then
    echo "API response is missing 'data' property:  $api_data" >/dev/stderr
    exit 1
  fi

  echo "$api_data" | jq -r '.[0].data'
}

function update_godaddy_ip {
  if [[ ${#@} -ne 1 ]]; then
    echo "Must supply a new IP address" >/dev/stderr
    exit 1
  fi

  local api_data
  api_data=$(curl -s -X PUT "https://api.godaddy.com/v1/domains/${DOMAIN_NAME}/records/A/${RECORD_NAME}" \
      -H "Authorization: sso-key ${API_KEY}:${API_SECRET}" \
      -H "Content-Type: application/json" \
      -d "[{\"data\": \"${1}\"}]")

  if [[ "$(echo "$api_data" | jq '.[0] | has("code")')" = "true" ]]; then
    echo "Failed to update A record - $api_data" >/dev/stderr
    exit 1
  fi
}

# Parse args
for item in "$@"; do
  case $item in
    -d=*|--domain=*|--domain-name=*)
      DOMAIN_NAME="${item#*=}"
      shift
      ;;
    -r=*|--record=*|--record-name=*)
      RECORD_NAME="${item#*=}"
      shift
      ;;
    -k=*|--key=*|--api-key=*)
      API_KEY="${item#*=}"
      shift
      ;;
    -s=*|--secret=*|--api-secret=*)
      API_SECRET="${item#*=}"
      shift
      ;;
    *)
      echo "Unknown option - $item" >/dev/stderr
      exit 1
      ;;
  esac
done

# Validate parameters
if [[ -z $API_KEY || -z $API_SECRET ]]; then
  echo "Missing API parameter(s)" >/dev/stderr
  exit 1
fi

# Get the current public IP address
public_ip=$(curl -s "https://api.ipify.org")
if [[ -z $public_ip ]]; then
  echo "Failed to obtain public IP address" >/dev/stderr
  exit 1
fi

# Lookup what the current IP registered with GoDaddy
godaddy_ip=$(retrieve_godaddy_ip)

# Log & update if necessary
echo "$(date '+%Y-%m-%d %H:%M:%S') - Current External IP is $public_ip, GoDaddy DNS IP is $godaddy_ip"
if [[ "$godaddy_ip" != "$public_ip" ]]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') - IP has changed!! Updating on GoDaddy"
  update_godaddy_ip "$public_ip"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Update succeeded"
fi

