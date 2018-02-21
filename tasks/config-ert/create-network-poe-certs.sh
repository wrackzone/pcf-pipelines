#!/usr/bin/bash

set -eo pipefail

function createNetworkingPoeCert() {
    local name=$1
    local cert=${2//$'\n'/'\n'}
    local key=${3//$'\n'/'\n'}
    local networking_poe_ssl_certs_json="{
      \"name\": \"$name\",
      \"certificate\": {
        \"cert_pem\": \"$cert\",
        \"private_key_pem\": \"$key\"
      }
    }"
    echo $networking_poe_ssl_certs_json
}

function generate_cert() {
    echo ""
}

function createNetworkingPoeCerts() {

    local sys_domain="${1:-$SYSTEM_DOMAIN}"
    local apps_domain="${2:-$APPS_DOMAIN}"

    local cert_name="${3:-$POE_SSL_NAME1}"
    local ssl_cert="${4:-$POE_SSL_CERT1}"
    local ssl_key="${5:-$POE_SSL_KEY1}"

    local cert_name2="${6:-$POE_SSL_NAME2}"
    local ssl_cert2="${7:-$POE_SSL_CERT2}"
    local ssl_key2="${8:-$POE_SSL_KEY2}"

    local cert_name3="${9:-$POE_SSL_NAME3}"
    local ssl_cert3="${10:-$POE_SSL_CERT3}"
    local ssl_key3="${11:-$POE_SSL_KEY3}"

#    echo "Vars: $*"

    if [[ "${cert_name}" == "" || "${cert_name}" == "null" ]]; then
      domains=(
        "*.${sys_domain}"
        "*.${apps_domain}"
        "*.login.${sys_domain}"
        "*.uaa.${sys_domain}"
      )

#      echo "Domains ${domains[*]}"

      cert_pair=$(generate_cert "${domains[*]}")
      ssl_cert=`echo $cert_pair | jq '.certificate'`
      ssl_key=`echo $cert_pair | jq '.key'`
      networking_poe_ssl_certs_json="[
        {
          \"name\": \"Certificate 1\",
          \"certificate\": {
            \"cert_pem\": ${ssl_cert},
            \"private_key_pem\": ${ssl_key}
          }
        }
      ]"
    else
        networking_poe_ssl_certs_json=$(createNetworkingPoeCert "${cert_name}" "${ssl_cert}" "${ssl_key}")
        if [[ ! "${cert_name2}" == "" && ! "${cert_name2}" == "null" ]]; then
            networking_poe_ssl_certs_json2=$(createNetworkingPoeCert "${cert_name2}" "${ssl_cert2}" "${ssl_key2}")
            networking_poe_ssl_certs_json="$networking_poe_ssl_certs_json,$networking_poe_ssl_certs_json2"
        fi
        if [[ ! "${cert_name3}" == "" && ! "${cert_name3}" == "null" ]]; then
            networking_poe_ssl_certs_json3=$(createNetworkingPoeCert "${cert_name3}" "${ssl_cert3}" "${ssl_key3}")
            networking_poe_ssl_certs_json="$networking_poe_ssl_certs_json,$networking_poe_ssl_certs_json3"
        fi
        networking_poe_ssl_certs_json="[$networking_poe_ssl_certs_json]"
    fi

    echo $networking_poe_ssl_certs_json
}