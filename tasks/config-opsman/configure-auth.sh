#!/bin/bash

set -e

function configure_authentication() {
  local opsman_domain_ip
  local opsman_user
  local opsman_password

  opsman_domain_ip="${1}"

  until $(curl --output /dev/null -k --silent --head --fail https://${opsman_domain_ip}/setup); do
      printf '.'
      sleep 5
  done

  opsman_user="${2}"
  opsman_password="${3}"
  opsman_decryp_password="${4}"

  om-linux \
    --target "https://${opsman_domain_ip}" \
    --skip-ssl-validation \
    configure-authentication \
    --username "${opsman_user}" \
    --password "${opsman_password}" \
    --decryption-passphrase "${opsman_decryp_password}"
}

export -f configure_authentication