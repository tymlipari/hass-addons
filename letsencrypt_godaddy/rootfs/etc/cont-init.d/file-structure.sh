#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Init folder & structures
# ==============================================================================
mkdir -p /data/workdir
mkdir -p /data/letsencrypt

# Setup Let's encrypt config
echo -e \
      "dns_godaddy_secret = $(bashio::config 'dns.godaddy_api_secret')\n" \
      "dns_godaddy_key = $(bashio::config 'dns.godaddy_api_key')\n" \
      "dns_rfc2136_server = $(bashio::config 'dns.rfc2136_server')\n" \
      "dns_rfc2136_port = $(bashio::config 'dns.rfc2136_port')\n" \
      "dns_rfc2136_name = $(bashio::config 'dns.rfc2136_name')\n" \
      "dns_rfc2136_secret = $(bashio::config 'dns.rfc2136_secret')\n" \
      "dns_rfc2136_algorithm = $(bashio::config 'dns.rfc2136_algorithm')\n" > /data/dnsapikey

chmod 600 /data/dnsapikey