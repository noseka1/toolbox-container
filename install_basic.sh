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

# install oc and kubectl
curl --location \
  https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz | \
  tar xvfz - --directory /usr/local/bin && \
  kubectl completion bash > /etc/bash_completion.d/kubectl && \
  oc completion bash > /etc/bash_completion.d/oc

# install etcd client
wget https://github.com/etcd-io/etcd/releases/download/v3.4.12/etcd-v3.4.12-linux-amd64.tar.gz && \
  tar xfz etcd-v3.4.12-linux-amd64.tar.gz --no-same-owner && \
  cp etcd-v3.4.12-linux-amd64/etcdctl /usr/local/bin && \
  rm -rf etcd-v3.4.12-linux-amd64*

# install fluentd
dnf install \
  --assumeyes \
  --setopt install_weak_deps=False \
  ruby-devel \
  gcc \
  gem \
  redhat-rpm-config \
  make && \
  gem install json --version 2.3.0 && \
  gem install fluentd --version 1.10.1

# install termshark
curl --location \
  https://github.com/gcla/termshark/releases/download/v2.1.1/termshark_2.1.1_linux_x64.tar.gz | \
  tar xvfz - --strip-components=1 --directory /usr/local/bin termshark_2.1.1_linux_x64/termshark
