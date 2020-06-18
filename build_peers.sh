#!/usr/bin/env bash


function clean {
	docker rm -f PEER_A || true
	docker rm -f PEER_B || true
	docker network rm wireguard || true
}

set -xe

PEER_A_WGIP="172.17.0.60"
PEER_B_WGIP="172.17.0.70"

PEER_A_DOCKERIP="10.40.45.60"
PEER_B_DOCKERIP="10.40.45.70"

PEER_A_PRIVKEY="$(wg genkey)"
PEER_B_PRIVKEY="$(wg genkey)"

PEER_A_PUBKEY="$(echo $PEER_A_PRIVKEY | wg pubkey)"
PEER_B_PUBKEY="$(echo $PEER_B_PRIVKEY | wg pubkey)"

docker build . -t wireguard-peer

clean
docker network create wireguard --subnet 10.40.45.0/24

# PEER A
docker run -d \
--network wireguard \
--name PEER_A \
--cap-add NET_ADMIN \
-e "WGIP=${PEER_A_WGIP}" \
-e "PRIVKEY=${PEER_A_PRIVKEY}" \
-e "PRIVKEY=${PEER_A_PRIVKEY}" \
-e "PEER_WGIP=${PEER_B_WGIP}" \
-e "PEER_PUBKEY=${PEER_B_PUBKEY}" \
-e "PEER_ENDPOINT=${PEER_B_DOCKERIP}" \
--ip ${PEER_A_DOCKERIP} \
wireguard-peer \
/bin/bash wireguard_server.sh

# PEER B
docker run -it --rm \
--network wireguard \
--name PEER_B \
--cap-add NET_ADMIN \
-e "WGIP=${PEER_B_WGIP}" \
-e "PRIVKEY=${PEER_B_PRIVKEY}" \
-e "PRIVKEY=${PEER_B_PRIVKEY}" \
-e "PEER_WGIP=${PEER_A_WGIP}" \
-e "PEER_PUBKEY=${PEER_A_PUBKEY}" \
-e "PEER_ENDPOINT=${PEER_A_DOCKERIP}" \
--ip ${PEER_B_DOCKERIP} \
wireguard-peer \
/bin/bash wireguard_bash.sh
clean

set +xe



