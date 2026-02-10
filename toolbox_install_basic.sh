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
  ethtool \
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
  hyperfine \
  iftop \
  iptables \
  iotop \
  iperf \
  iperf3 \
  iproute \
  iputils \
  jq \
  lsof \
  man-db \
  mtr \
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
  stress-ng \
  symlinks \
  sysstat \
  tcpdump \
  traceroute \
  unzip \
  vim \
  wget \
  wireshark-cli \
  xz

dnf clean all

# Install tini
github_download_latest_asset krallin/tini "tini" > $install_dir/tini &&
  chmod 755 $install_dir/tini

# Install termshark
github_download_latest_asset gcla/termshark "termshark_.*_linux_x64.tar.gz" | \
  tar xvfz - --directory $install_dir --strip-components=1 --wildcards termshark_*_linux_x64/termshark

# Install mitmproxy
ver=10.4.2
curl --location --no-progress-meter \
  https://downloads.mitmproxy.org/${ver}/mitmproxy-${ver}-linux-x86_64.tar.gz | \
  tar xvfz - --directory $install_dir

# Install zenith
github_download_latest_asset bvaisvil/zenith "zenith-Linux-musl-x86_64.tar.gz" | \
  tar xvfz - --directory $install_dir zenith

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

# Create a toolbox user
adduser toolbox \
  --no-create-home \
  --gid root \
  --groups wheel
mkdir /home/toolbox

# Grant write access to user in group root
for f in /etc/passwd /etc/group /home; do
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

# Set owner = toolbox, group = root for all files in toolbox's home directory
chown -R toolbox:root ~toolbox

# Make all files that are writeable by owner also writeable by (root) group
find ~toolbox -perm -u+w -exec chmod g+w {} +
