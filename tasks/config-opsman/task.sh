#!/bin/bash

set -e

source ./configure-auth.sh

configure_authentication "${OPSMAN_DOMAIN_OR_IP_ADDRESS}" "${OPS_MGR_USR}" "${OPS_MGR_PWD}" "${OM_DECRYPTION_PWD}"
