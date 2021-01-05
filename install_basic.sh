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

# install termshark
curl --location \
  https://github.com/gcla/termshark/releases/download/v2.1.1/termshark_2.1.1_linux_x64.tar.gz | \
  tar xvfz - --strip-components=1 --directory /usr/local/bin termshark_2.1.1_linux_x64/termshark
