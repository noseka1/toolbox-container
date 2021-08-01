#!/bin/bash -x

dnf install \
  --assumeyes \
  --setopt install_weak_deps=False \
  bind-utils \
  blktrace \
  bzip2 \
  curl \
  diffutils \
  dnsmasq \
  fd-find \
  file \
  findutils \
  gdb \
  git \
  golang \
  httpd \
  haproxy \
  hostname \
  htop \
  iftop \
  iotop \
  iperf \
  iproute \
  iputils \
  jq \
  lsof \
  man-db \
  net-tools \
  nmap \
  nmap-ncat \
  openssl \
  patch \
  procps-ng \
  psmisc \
  python3-gunicorn \
  python3-httpbin \
  python3-pygments \
  socat \
  strace \
  tcpdump \
  telnet \
  unzip \
  vim \
  wget \
  wireshark-cli \
  xz

dnf clean all

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
. $SCRIPT_DIR/toolbox_install_common.sh

# install termshark
REPO=gcla/termshark
get_latest $REPO
curl --location \
  https://github.com/$REPO/releases/download/$TAG/termshark_${VER}_linux_x64.tar.gz | \
  tar xvfz - --directory $INSTALL_DIR --strip-components=1 termshark_${VER}_linux_x64/termshark

# install delve (Golang debugger)
REPO=go-delve/delve
get_latest $REPO
TMPDIR=$(mktemp --directory --suffix -dlv)
(
  cd $TMPDIR
  go mod init local/build
  go get github.com/go-delve/delve/cmd/dlv@$TAG
  rm -rf $TMPDIR
)
ln --force /root/go/bin/dlv $INSTALL_DIR
