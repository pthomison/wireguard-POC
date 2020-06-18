# wireguard proof of concept

```
./build_peers.sh
+ PEER_A_WGIP=172.17.0.60
+ PEER_B_WGIP=172.17.0.70
+ PEER_A_DOCKERIP=10.40.45.60
+ PEER_B_DOCKERIP=10.40.45.70
++ wg genkey
+ PEER_A_PRIVKEY=WM2g85xrO8CQYAzBcsikiOvcm7rMMgUs0shO7pBPVVQ=
++ wg genkey
+ PEER_B_PRIVKEY=oDIZ3g6nOjTe9bL3z2fs6QfT0kAlksJG3wMQlT3X+FI=
++ echo WM2g85xrO8CQYAzBcsikiOvcm7rMMgUs0shO7pBPVVQ=
++ wg pubkey
+ PEER_A_PUBKEY=8buYUSUK8LLkRE//pxdfjyBgyYQne5I+LHwJ3DT7zXY=
++ echo oDIZ3g6nOjTe9bL3z2fs6QfT0kAlksJG3wMQlT3X+FI=
++ wg pubkey
+ PEER_B_PUBKEY=s/PPpbAsD0WN/YGf831KndNaddtgPuipjKcP4mUDDXM=
+ docker build . -t wireguard-peer
Sending build context to Docker daemon  68.61kB
Step 1/11 : FROM fedora:32 as build
 ---> 2a8d315e6208
Step 2/11 : RUN dnf update -y
 ---> Using cache
 ---> 5eaf3d97d7fb
Step 3/11 : RUN dnf install make git gcc iproute kmod wireguard-tools procps-ng -y
 ---> Using cache
 ---> e7a2c792177b
Step 4/11 : RUN curl https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz -o /opt/go1.14.3.linux-amd64.tar.gz && tar -xf /opt/go1.14.3.linux-amd64.tar.gz -C /opt/ && ln -s /opt/go/bin/go /usr/bin/go && ln -s /opt/go/bin/gofmt /usr/bin/gofmt
 ---> Using cache
 ---> 30de62b38553
Step 5/11 : ENV PATH /go/bin:$PATH
 ---> Using cache
 ---> 892bd4a96d4f
Step 6/11 : ENV GOPATH /go/
 ---> Using cache
 ---> 7c0f15bb59c5
Step 7/11 : ENV GOCACHE /tmp/
 ---> Using cache
 ---> 10afc5b0bd13
Step 8/11 : RUN go get git.zx2c4.com/wireguard-go
 ---> Using cache
 ---> 19c545a15bf6
Step 9/11 : RUN go get github.com/hairyhenderson/gomplate/cmd/gomplate
 ---> Using cache
 ---> d68cde26799e
Step 10/11 : COPY wg.conf.tpl /wg.conf.tpl
 ---> Using cache
 ---> cda340bd541a
Step 11/11 : COPY *.sh /
 ---> Using cache
 ---> 2ea035b32063
Successfully built 2ea035b32063
Successfully tagged wireguard-peer:latest
+ clean
+ docker rm -f PEER_A
PEER_A
+ docker rm -f PEER_B
Error: No such container: PEER_B
+ true
+ docker network rm wireguard
wireguard
+ docker network create wireguard --subnet 10.40.45.0/24
e7854b39aae8e80dd12b5bc936cc46a2dd691cb88f4b5a9f93cc2ff9ad7174d7
+ docker run -d --network wireguard --name PEER_A --cap-add NET_ADMIN -e WGIP=172.17.0.60 -e PRIVKEY=WM2g85xrO8CQYAzBcsikiOvcm7rMMgUs0shO7pBPVVQ= -e PRIVKEY=WM2g85xrO8CQYAzBcsikiOvcm7rMMgUs0shO7pBPVVQ= -e PEER_WGIP=172.17.0.70 -e PEER_PUBKEY=s/PPpbAsD0WN/YGf831KndNaddtgPuipjKcP4mUDDXM= -e PEER_ENDPOINT=10.40.45.70 --ip 10.40.45.60 wireguard-peer /bin/bash wireguard_server.sh
9ba3ab5703f5ae2a21844bda17568e694e82019f4d37997fc4a511c4d4936b63
+ docker run -it --rm --network wireguard --name PEER_B --cap-add NET_ADMIN -e WGIP=172.17.0.70 -e PRIVKEY=oDIZ3g6nOjTe9bL3z2fs6QfT0kAlksJG3wMQlT3X+FI= -e PRIVKEY=oDIZ3g6nOjTe9bL3z2fs6QfT0kAlksJG3wMQlT3X+FI= -e PEER_WGIP=172.17.0.60 -e PEER_PUBKEY=8buYUSUK8LLkRE//pxdfjyBgyYQne5I+LHwJ3DT7zXY= -e PEER_ENDPOINT=10.40.45.60 --ip 10.40.45.70 wireguard-peer /bin/bash wireguard_bash.sh
++ mkdir /dev/net
++ mknod /dev/net/tun c 10 200
++ cat /wg.conf.tpl
++ gomplate

++ cat /root/wg0.conf
[Interface]
PrivateKey = oDIZ3g6nOjTe9bL3z2fs6QfT0kAlksJG3wMQlT3X+FI=
ListenPort = 51820

[Peer]
PublicKey = 8buYUSUK8LLkRE//pxdfjyBgyYQne5I+LHwJ3DT7zXY=
AllowedIPs = 172.17.0.60/32
Endpoint = 10.40.45.60:51820++ wireguard-go wg0
┌───────────────────────────────────────────────────┐
│                                                   │
│   Running this software on Linux is unnecessary,  │
│   because the Linux kernel has built-in first     │
│   class support for WireGuard, which will be      │
│   faster, slicker, and better integrated. For     │
│   information on installing the kernel module,    │
│   please visit: <https://wireguard.com/install>.  │
│                                                   │
└───────────────────────────────────────────────────┘
INFO: (wg0) 2020/06/18 16:18:37 Starting wireguard-go version 0.0.20200320
++ ip address add dev wg0 172.17.0.70/24
++ wg setconf wg0 /root/wg0.conf
++ ip link set up dev wg0
++ set +xe
[root@62118e96f8cf /]# curl 172.17.0.60:8080
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Directory listing for /</title>
</head>
<body>
<h1>Directory listing for /</h1>
<hr>
<ul>
<li><a href=".dockerenv">.dockerenv</a></li>
<li><a href="bin/">bin@</a></li>
<li><a href="boot/">boot/</a></li>
<li><a href="build_peers.sh">build_peers.sh</a></li>
<li><a href="dev/">dev/</a></li>
<li><a href="etc/">etc/</a></li>
<li><a href="go/">go/</a></li>
<li><a href="home/">home/</a></li>
<li><a href="lib/">lib@</a></li>
<li><a href="lib64/">lib64@</a></li>
<li><a href="lost%2Bfound/">lost+found/</a></li>
<li><a href="media/">media/</a></li>
<li><a href="mnt/">mnt/</a></li>
<li><a href="opt/">opt/</a></li>
<li><a href="proc/">proc/</a></li>
<li><a href="root/">root/</a></li>
<li><a href="run/">run/</a></li>
<li><a href="sbin/">sbin@</a></li>
<li><a href="setup_wireguard.sh">setup_wireguard.sh</a></li>
<li><a href="srv/">srv/</a></li>
<li><a href="sys/">sys/</a></li>
<li><a href="tmp/">tmp/</a></li>
<li><a href="usr/">usr/</a></li>
<li><a href="var/">var/</a></li>
<li><a href="wg.conf.tpl">wg.conf.tpl</a></li>
<li><a href="wireguard_bash.sh">wireguard_bash.sh</a></li>
<li><a href="wireguard_server.sh">wireguard_server.sh</a></li>
</ul>
<hr>
</body>
</html>
```