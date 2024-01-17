#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

# set environment variables with config info
bashio::config.require 'cloudflare_api_key'
export CF_DNS__AUTH__SCOPED_TOKEN=$(bashio::config 'cloudflare_api_key')

bashio::config.require 'domain_name'
export CF_DNS__DOMAINS_0__NAME=$(bashio::config 'domain_name')