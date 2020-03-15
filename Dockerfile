FROM registry.redhat.io/ubi8/ubi

RUN dnf install \
  --assumeyes \
  bind-utils \
  curl \
  gdb \
  git \
  highlight \
  iotop \
  iproute \
  lsof \
  net-tools \
  patch \
  socat \
  strace \
  tcpdump \
  vim \
  wget

RUN dnf install \
  --assumeyes \
  --enablerepo rhocp-4.3-for-rhel-8-x86_64-rpms \
  buildah \
  openshift-clients \
  podman \
  skopeo

RUN dnf install \
  --assumeyes \
  --enablerepo ansible-2-for-rhel-8-x86_64-rpms \
  ansible

RUN mkdir /home/toolbox && \
  chgrp 0 /home/toolbox && \
  chmod 775 /home/toolbox

WORKDIR /home/toolbox
