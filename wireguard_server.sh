#!/usr/bin/env bash

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# EXPECTED ENV VARS

# WGIP
# PRIVKEY
# PUBKEY
# PEER_WGIP
# PEER_PUBKEY
# PEER_ENDPOINT

source ${SCRIPTS_DIR}/setup_wireguard.sh

python3 -m http.server 8080