FROM fedora:latest as basic

ARG OPENSHIFT_TOOLBOX_COMMIT=unspecified
ENV OPENSHIFT_TOOLBOX_COMMIT $OPENSHIFT_TOOLBOX_COMMIT

RUN dnf install \
  --assumeyes \
  --setopt install_weak_deps=False \
  bind-utils \
  bzip2 \
  curl \
  dnsmasq \
  gdb \
  git \
  highlight \
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
  socat \
  strace \
  tcpdump \
  telnet \
  vim \
  wget \
  wireshark-cli

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
  --setopt install_weak_deps=False \
  ruby-devel \
  gcc \
  gem \
  redhat-rpm-config \
  make && \
  gem install json --version 2.3.0 && \
  gem install fluentd --version 1.10.1

# install termshark
RUN curl --location \
  https://github.com/gcla/termshark/releases/download/v2.1.1/termshark_2.1.1_linux_x64.tar.gz | \
  tar xvfz - --strip-components=1 --directory /usr/local/bin termshark_2.1.1_linux_x64/termshark

# add start script
COPY start.sh /usr/local/bin

RUN adduser toolbox --groups wheel && \
  chgrp 0 /home/toolbox && \
  chmod 775 /home/toolbox

# allow sudo without password
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

WORKDIR /home/toolbox

CMD [ "/usr/local/bin/start.sh" ]

#########################
#      STAGE  FULL      #
#########################

FROM basic as full

RUN dnf install \
  --assumeyes \
  --setopt install_weak_deps=False \
  ansible \
  awscli \
  buildah \
  fzf \
  podman \
  skopeo \
  the_silver_searcher \
  tmux

# install s2i
RUN curl --location \
  https://github.com/openshift/source-to-image/releases/download/v1.3.0/source-to-image-v1.3.0-eed2850f-linux-amd64.tar.gz | \
  tar xvfz - --directory /usr/local/bin && \
  chmod 755 /usr/local/bin/s2i

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

# install kustomize
RUN curl --location \
  --output /usr/local/bin/kustomize \
  https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.2.2/kustomize_kustomize.v3.2.2_linux_amd64 && \
  chmod 755 /usr/local/bin/kustomize

# install odo
RUN curl --location \
  --output /usr/local/bin/odo \
  https://mirror.openshift.com/pub/openshift-v4/clients/odo/latest/odo-linux-amd64 && \
  chmod 755 /usr/local/bin/odo

# install kn (serverless client)
RUN curl --location \
  https://mirror.openshift.com/pub/openshift-v4/clients/serverless/latest/kn-linux-amd64-0.13.2.tar.gz | \
  tar xvfz - --directory /usr/local/bin && \
  chmod 755 /usr/local/bin/kn

# install tekton cli
RUN rpm --install https://github.com/tektoncd/cli/releases/download/v0.9.0/tektoncd-cli-0.9.0_Linux-64bit.rpm

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

# install fortio
RUN rpm --install https://github.com/fortio/fortio/releases/download/v1.3.1/fortio-1.3.1-1.x86_64.rpm

# install lazygit
RUN curl --location \
  https://github.com/jesseduffield/lazygit/releases/download/v0.20.2/lazygit_0.20.2_Linux_x86_64.tar.gz | \
  tar xvfz - --directory /usr/local/bin && \
  chmod 755 /usr/local/bin/lazygit

# install gitmux
RUN curl --location \
  https://github.com/arl/gitmux/releases/download/v0.5.0/gitmux_0.5.0_linux_amd64.tar.gz | \
  tar xvfz - --directory /usr/local/bin

# install dive
RUN dnf install \
  --assumeyes \
  --setopt install_weak_deps=False \
  https://github.com/wagoodman/dive/releases/download/v0.9.2/dive_0.9.2_linux_amd64.rpm

# install argocd
RUN curl --location \
  --output /usr/local/bin/argocd \
  https://github.com/argoproj/argo-cd/releases/download/v1.5.5/argocd-linux-amd64 && \
  chmod 755 /usr/local/bin/argocd
