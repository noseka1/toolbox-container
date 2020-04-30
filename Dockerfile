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
  vim \
  wget

# install oc and kubectl
RUN curl --location \
  https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz | \
  tar xvfz - --directory /usr/local/bin

# install etcd client
RUN wget https://github.com/etcd-io/etcd/releases/download/v3.4.7/etcd-v3.4.7-linux-amd64.tar.gz && \
  tar xfz etcd-v3.4.7-linux-amd64.tar.gz --no-same-owner && \
  cp etcd-v3.4.7-linux-amd64/etcdctl /usr/local/bin && \
  rm -rf etcd-v3.4.7-linux-amd64*

# install fluentd
RUN dnf install \
  --assumeyes \
  ruby-devel \
  gcc \
  gem \
  redhat-rpm-config \
  make && \
  gem install fluentd --version 1.10.1

RUN mkdir /home/toolbox && \
  chgrp 0 /home/toolbox && \
  chmod 775 /home/toolbox

WORKDIR /home/toolbox

CMD [ "/bin/bash" ]

FROM basic as full

RUN dnf install \
  --assumeyes \
  ansible \
  awscli \
  buildah \
  fzf \
  podman \
  skopeo \
  tmux

# install noobaa
RUN curl --location \
  --output /usr/local/bin/noobaa \
  https://github.com/noobaa/noobaa-operator/releases/download/v2.1.1/noobaa-linux-v2.1.1 && \
  chmod 755 /usr/local/bin/noobaa

# install helm
RUN curl --location \
  --output /usr/local/bin/helm \
  https://mirror.openshift.com/pub/openshift-v4/clients/helm/latest/helm-linux-amd64 && \
  chmod 755 /usr/local/bin/helm

# install operator sdk
RUN curl --location \
  --output /usr/local/bin/operator-sdk \
  https://github.com/operator-framework/operator-sdk/releases/download/v0.17.0/operator-sdk-v0.17.0-x86_64-linux-gnu && \
  chmod 755 /usr/local/bin/operator-sdk

# install stern
RUN curl --location \
  --output /usr/local/bin/stern \
  https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64 && \
  chmod 755 /usr/local/bin/stern

# install kubens and kubectx
RUN curl --location \
  --output /usr/local/bin/kubens \
  https://github.com/ahmetb/kubectx/releases/download/v0.9.0/kubens && \
  chmod 755 /usr/local/bin/kubens && \
  curl --location \
  --output /usr/local/bin/kubectx \
  https://github.com/ahmetb/kubectx/releases/download/v0.9.0/kubectx && \
  chmod 755 /usr/local/bin/kubectx
