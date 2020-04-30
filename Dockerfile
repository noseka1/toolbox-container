FROM fedora:latest as basic

RUN dnf install \
  --assumeyes \
  bind-utils \
  bzip2 \
  curl \
  gdb \
  git \
  highlight \
  httpd \
  haproxy \
  hostname \
  htop \
  iotop \
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
  python3-httpbin \
  socat \
  strace \
  tcpdump \
  tmux \
  vim \
  wget

RUN dnf install \
  --assumeyes \
  buildah \
  podman \
  skopeo

RUN dnf install \
  --assumeyes \
  ansible

RUN dnf install \
  --assumeyes \
  awscli

# install oc and kubectl
RUN curl --location \
  https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.4.0/openshift-client-linux-4.4.0.tar.gz | \
  tar xvfz - --directory /usr/local/bin

# install noobaa
RUN curl --location \
  --output /usr/local/bin/noobaa \
  https://github.com/noobaa/noobaa-operator/releases/download/v2.0.10/noobaa-linux-v2.0.10 && \
  chmod 755 /usr/local/bin/noobaa

# install fluentd
RUN dnf install \
  --assumeyes \
  ruby-devel \
  gcc \
  gem \
  redhat-rpm-config \
  make && \
  gem install fluentd --version 1.10.1

# install etcd client
RUN wget https://github.com/etcd-io/etcd/releases/download/v3.4.7/etcd-v3.4.7-linux-amd64.tar.gz && \
  tar xfz etcd-v3.4.7-linux-amd64.tar.gz --no-same-owner && \
  cp etcd-v3.4.7-linux-amd64/etcdctl /usr/local/bin && \
  rm -rf etcd-v3.4.7-linux-amd64*

RUN mkdir /home/toolbox && \
  chgrp 0 /home/toolbox && \
  chmod 775 /home/toolbox

WORKDIR /home/toolbox

CMD [ "/bin/bash" ]

FROM basic

RUN dnf install \
  --assumeyes \
  fzf \
  tmux
