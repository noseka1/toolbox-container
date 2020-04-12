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
  hostname \
  iotop \
  iproute \
  iputils \
  lsof \
  man-db \
  net-tools \
  nmap-ncat \
  patch \
  procps-ng \
  psmisc \
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
  --output /usr/local/bin/noobaa \
  https://github.com/noobaa/noobaa-operator/releases/download/v2.0.10/noobaa-linux-v2.0.10 && \
  chmod 755 /usr/local/bin/noobaa

RUN dnf install \
  --assumeyes \
  ruby-devel \
  gem \
  redhat-rpm-config \
  make && \
  gem install fluentd --version 1.10.1

RUN dnf install \
  --assumeyes \
  --enablerepo rhocp-4.3-for-rhel-8-x86_64-rpms \
  python3-gunicorn && \
  pip3 install httpbin==0.7.0

# install etcd client
RUN wget https://github.com/etcd-io/etcd/releases/download/v3.4.7/etcd-v3.4.7-linux-amd64.tar.gz && \
  tar xfz etcd-v3.4.7-linux-amd64.tar.gz && \
  cp etcd-v3.4.7-linux-amd64/etcdctl /usr/local/bin && \
  rm -rf etcd-v3.4.7-linux-amd64*

RUN mkdir /home/toolbox && \
  chgrp 0 /home/toolbox && \
  chmod 775 /home/toolbox

WORKDIR /home/toolbox

CMD [ "/usr/bin/sleep", "infinity" ]
