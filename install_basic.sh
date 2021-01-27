#!/bin/bash -x

dnf install \
  --assumeyes \
  --setopt install_weak_deps=False \
  bind-utils \
  bzip2 \
  curl \
  diffutils \
  dnsmasq \
  fd-find \
  findutils \
  gdb \
  git \
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
  vim \
  wget \
  wireshark-cli
