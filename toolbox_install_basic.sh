#!/bin/bash

set -euo pipefail

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
. $script_dir/toolbox_install_common.sh

# Create toolbox user
adduser toolbox --groups wheel
chgrp 0 ~toolbox
chmod 775 ~toolbox

# Allow adding user with arbitrary uid on container start
for f in /etc/passwd /etc/group; do
  chgrp 0 $f
  chmod g+w $f
done

# Allow sudo without password
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/10_wheel_nopasswd

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
  dnsmasq \
  duf \
  fatrace \
  fd-find \
  file \
  findutils \
  fio \
  gdb \
  git \
  httpd \
  haproxy \
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
  net-tools \
  nginx \
  nmap \
  nmap-ncat \
  openssh-server \
  openssl \
  patch \
  procps-ng \
  psmisc \
  python3-gunicorn \
  python3-httpbin \
  python3-pygments \
  ripgrep \
  rsync \
  socat \
  strace \
  symlinks \
  tcpdump \
  telnet \
  unzip \
  vim \
  wget \
  wireshark-cli \
  xz

dnf clean all

# Disable SELinux ssh module to allow ssh clients to log in
sed -i '/selinux/d' /etc/pam.d/sshd
# Disable checking of file ownership/mode in the user's home dir
sed -i 's/^#StrictModes yes/StrictModes no/' /etc/ssh/sshd_config
# Create an empty authorized_keys file for user toolbox
mkdir ~toolbox/.ssh
chown toolbox:toolbox ~toolbox/.ssh
> ~toolbox/.ssh/authorized_keys
chown toolbox:toolbox ~toolbox/.ssh/authorized_keys

# Install termshark
github_download_latest_asset gcla/termshark "termshark_.*_linux_x64.tar.gz" | \
  tar xvfz - --directory $install_dir --strip-components=1 --wildcards termshark_*_linux_x64/termshark

# Install mitmproxy
ver=10.1.5
curl --location --no-progress-meter \
  https://snapshots.mitmproxy.org/${ver}/mitmproxy-${ver}-linux.tar.gz | \
  tar xvfz - --directory $install_dir

# Install sysdig
github_get_latest_asset draios/sysdig sysdig-.*-x86_64.rpm
rpm --install --nodeps $github_asset_url

# Install zenith
github_download_latest_asset bvaisvil/zenith "zenith.x86_64-unknown-linux-musl.tgz$" | \
  tar xvfz - --directory $install_dir

# Install yq
github_download_latest_asset mikefarah/yq yq_linux_amd64 \
  > $install_dir/yq && \
  chmod 755 $install_dir/yq
