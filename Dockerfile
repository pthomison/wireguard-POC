FROM fedora:32 as build

RUN dnf update -y
RUN dnf install make git gcc iproute kmod wireguard-tools procps-ng -y

# install go
RUN curl https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz -o /opt/go1.14.3.linux-amd64.tar.gz && \
tar -xf /opt/go1.14.3.linux-amd64.tar.gz -C /opt/ && \
ln -s /opt/go/bin/go /usr/bin/go && \
ln -s /opt/go/bin/gofmt /usr/bin/gofmt

ENV PATH /go/bin:$PATH
ENV GOPATH /go/
ENV GOCACHE /tmp/

RUN go get git.zx2c4.com/wireguard-go
RUN go get github.com/hairyhenderson/gomplate/cmd/gomplate

COPY wg.conf.tpl /wg.conf.tpl

COPY *.sh /
