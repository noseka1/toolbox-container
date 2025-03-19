#!/bin/bash

set -euo pipefail

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
. $script_dir/toolbox_install_common.sh

dnf install \
  --assumeyes \
  --setopt install_weak_deps=False \
  binutils \
  bind-utils \
  blktrace \
  bzip2 \
  curl \
  ddrescue \
  diffutils \
  e2fsprogs \
  fatrace \
  fd-find \
  file \
  findutils \
  fio \
  fio-engine-libaio \
  gdb \
  git \
  hostname \
  htop \
  iftop \
  iptables \
  iotop \
  iperf \
  iproute \
  iputils \
  jq \
  lsof \
  man-db \
  nmon \
  nmap \
  nmap-ncat \
  numactl \
  openssh-server \
  openssl \
  patch \
  procps-ng \
  psmisc \
  python3-gunicorn \
  python3-httpbin \
  ripgrep \
  rsync \
  socat \
  strace \
  symlinks \
  sysstat \
  tcpdump \
  unzip \
  vim \
  wget \
  wireshark-cli \
  xz

dnf clean all

# Create toolbox user
adduser toolbox --gid root --groups wheel
chgrp root ~toolbox
chmod 775 ~toolbox

# Allow adding user with arbitrary uid on container start
for f in /etc/passwd /etc/group; do
  chgrp root $f
  chmod g+w $f
done

# Allow sudo without password
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/10_wheel_nopasswd

# Enable SSH login

# Disable SELinux ssh module to allow ssh clients to log in
sed -i '/selinux/d' /etc/pam.d/sshd
# Disable checking of file ownership/mode in the user's home dir
sed -i 's/^#StrictModes yes/StrictModes no/' /etc/ssh/sshd_config
# Create an empty authorized_keys file for user toolbox
mkdir ~toolbox/.ssh
> ~toolbox/.ssh/authorized_keys

# All files in toolbox's home directory should be owned by toolbox
chown -R toolbox:root ~toolbox

# Install termshark
github_download_latest_asset gcla/termshark "termshark_.*_linux_x64.tar.gz" | \
  tar xvfz - --directory $install_dir --strip-components=1 --wildcards termshark_*_linux_x64/termshark

# Install mitmproxy
ver=10.4.2
curl --location --no-progress-meter \
  https://downloads.mitmproxy.org/${ver}/mitmproxy-${ver}-linux-x86_64.tar.gz | \
  tar xvfz - --directory $install_dir

# Install zenith
github_download_latest_asset bvaisvil/zenith "zenith.x86_64-unknown-linux-musl.tgz" | \
  tar xvfz - --directory $install_dir

# Install yq
github_download_latest_asset mikefarah/yq yq_linux_amd64 \
  > $install_dir/yq && \
  chmod 755 $install_dir/yq

# Install grpcurl
github_download_latest_asset fullstorydev/grpcurl "grpcurl_.*_linux_x86_64.tar.gz" | \
  tar xvfz - --directory $install_dir --no-same-owner grpcurl

# Install bandwhich
github_download_latest_asset imsnif/bandwhich "bandwhich-v.*-x86_64-unknown-linux-gnu.tar.gz" | \
  tar xvfz - --directory $install_dir bandwhich
