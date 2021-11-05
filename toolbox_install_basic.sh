#!/bin/bash -x

set -e

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

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
. $script_dir/toolbox_install_common.sh

# install termshark
repo=gcla/termshark
get_latest $repo
curl --location \
  https://github.com/$repo/releases/download/$tag/termshark_${ver}_linux_x64.tar.gz | \
  tar xvfz - --directory $install_dir --strip-components=1 termshark_${ver}_linux_x64/termshark
