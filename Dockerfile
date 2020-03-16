FROM registry.redhat.io/ubi8/ubi

RUN dnf install \
  --assumeyes \
  bind-utils \
  curl \
  gdb \
  git \
  highlight \
  httpd \
  haproxy \
  iotop \
  iproute \
  lsof \
  man-db \
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

RUN dnf install \
  --assumeyes \
  --enablerepo rhel-8-for-x86_64-highavailability-rpms \
  awscli

RUN curl --location \
  --output /usr/local/bin/nooba \
  https://github.com/noobaa/noobaa-operator/releases/download/v2.0.10/noobaa-linux-v2.0.10 && \
  chmod 755 /usr/local/bin/nooba

RUN mkdir /home/toolbox && \
  chgrp 0 /home/toolbox && \
  chmod 775 /home/toolbox

WORKDIR /home/toolbox

CMD [ "/usr/bin/sleep", "infinity" ]
