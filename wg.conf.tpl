[Interface]
PrivateKey = {{ .Env.PRIVKEY }}
ListenPort = 51820

[Peer]
PublicKey = {{ .Env.PEER_PUBKEY }}
AllowedIPs = {{ .Env.PEER_WGIP }}/32
Endpoint = {{ .Env.PEER_ENDPOINT }}:51820