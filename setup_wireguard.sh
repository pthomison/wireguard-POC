#!/usr/bin/env bash

# EXPECTED ENV VARS

# WGIP
# PRIVKEY
# PUBKEY
# PEER_WGIP
# PEER_PUBKEY
# PEER_ENDPOINT

set -xe

mkdir /dev/net 
mknod /dev/net/tun c 10 200

cat /wg.conf.tpl | gomplate > /root/wg0.conf

cat /root/wg0.conf

wireguard-go wg0

ip address add dev wg0 ${WGIP}/24

wg setconf wg0 /root/wg0.conf

ip link set up dev wg0

set +xe