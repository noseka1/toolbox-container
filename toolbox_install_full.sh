#!/bin/bash -x

dnf install \
  --assumeyes \
  --setopt install_weak_deps=False \
  ansible \
  awscli \
  buildah \
  fzf \
  golang \
  podman \
  python3-kubernetes \
  python3-openshift \
  runc \
  skopeo \
  ripgrep \
  tmux \
  xz

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

dnf clean all

INSTALL_DIR=/usr/local/bin

function get_latest() {
  TAG=$(curl https://api.github.com/repos/$REPO/releases | jq --raw-output '.[0].tag_name')
  VER=${TAG#v}
}

# install termshark
REPO=gcla/termshark
get_latest $REPO
curl --location \
  https://github.com/$REPO/releases/download/$TAG/termshark_${VER}_linux_x64.tar.gz | \
  tar xvfz - --directory $INSTALL_DIR --strip-components=1 termshark_${VER}_linux_x64/termshark

# install oc and kubectl
curl --location \
  https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz | \
  tar xvfz - --directory $INSTALL_DIR && \
  kubectl completion bash > /etc/bash_completion.d/kubectl && \
  oc completion bash > /etc/bash_completion.d/oc

# install etcd client
REPO=etcd-io/etcd
get_latest $REPO
curl --location \
  https://github.com/$REPO/releases/download/$TAG/etcd-$TAG-linux-amd64.tar.gz | \
  tar xvfz - etcd-$TAG-linux-amd64/etcdctl --directory $INSTALL_DIR --strip-components=1 --no-same-owner

# install delve (Golang debugger)
go get github.com/go-delve/delve/cmd/dlv
ln --force /root/go/bin/dlv $INSTALL_DIR

# install s2i
curl --location \
  https://github.com/openshift/source-to-image/releases/download/v1.3.1/source-to-image-v1.3.1-a5a77147-linux-amd64.tar.gz | \
  tar xvfz - --directory $INSTALL_DIR --strip-components=1

# install noobaa
REPO=noobaa/noobaa-operator
get_latest $REPO
curl --location \
  --output $INSTALL_DIR/noobaa \
  https://github.com/$REPO/releases/download/$TAG/noobaa-linux-$TAG && \
  chmod 755 $INSTALL_DIR/noobaa

# install helm
curl --location \
  --output $INSTALL_DIR/helm \
  https://mirror.openshift.com/pub/openshift-v4/clients/helm/latest/helm-linux-amd64 && \
  chmod 755 $INSTALL_DIR/helm

# install operator sdk
REPO=operator-framework/operator-sdk
get_latest $REPO
curl --location \
  --output $INSTALL_DIR/operator-sdk \
  https://github.com/$REPO/releases/download/$TAG/operator-sdk-$TAG-x86_64-linux-gnu && \
  chmod 755 $INSTALL_DIR/operator-sdk

# install kustomize
REPO=kubernetes-sigs/kustomize
TAG=v4.1.2
VER=4.1.2
curl --location \
  https://github.com/$REPO/releases/download/kustomize/$TAG/kustomize_${TAG}_linux_amd64.tar.gz | \
  tar xvfz - --directory $INSTALL_DIR && \
  chmod 755 $INSTALL_DIR/kustomize

# install odo
curl --location \
  --output $INSTALL_DIR/odo \
  https://mirror.openshift.com/pub/openshift-v4/clients/odo/latest/odo-linux-amd64 && \
  chmod 755 $INSTALL_DIR/odo

# install kn (serverless client)
curl --location \
  https://mirror.openshift.com/pub/openshift-v4/clients/serverless/latest/kn-linux-amd64.tar.gz | \
  tar xvfz - --directory $INSTALL_DIR && \
  chmod 755 $INSTALL_DIR/kn

# install tekton cli
REPO=tektoncd/cli
get_latest $REPO
rpm --install https://github.com/$REPO/releases/download/$TAG/tektoncd-cli-${VER}_Linux-64bit.rpm

# install stern
REPO=stern/stern
get_latest $REPO
curl --location \
  https://github.com/$REPO/releases/download/$TAG/stern_${VER}_linux_amd64.tar.gz | \
  tar xvfz - stern_${VER}_linux_amd64/stern --directory $INSTALL_DIR --strip-components=1 && \
  chmod 755 $INSTALL_DIR/stern

# install kubens and kubectx
REPO=ahmetb/kubectx
get_latest $REPO
curl --location \
  --output $INSTALL_DIR/kubens \
  https://github.com/$REPO/releases/download/$TAG/kubens && \
  chmod 755 $INSTALL_DIR/kubens && \
curl --location \
  --output $INSTALL_DIR/kubectx \
  https://github.com/$REPO/releases/download/$TAG/kubectx && \
  chmod 755 $INSTALL_DIR/kubectx

# install fortio
REPO=fortio/fortio
get_latest $REPO
rpm --install https://github.com/$REPO/releases/download/$TAG/fortio-$VER-1.x86_64.rpm

# install lazygit
REPO=jesseduffield/lazygit
get_latest $REPO
curl --location \
  https://github.com/$REPO/releases/download/$TAG/lazygit_${VER}_Linux_x86_64.tar.gz | \
  tar xvfz - --directory $INSTALL_DIR && \
  chmod 755 $INSTALL_DIR/lazygit

# install gitmux
REPO=arl/gitmux
get_latest $REPO
curl --location \
  https://github.com/$REPO/releases/download/$TAG/gitmux_${VER}_linux_amd64.tar.gz | \
  tar xvfz - --directory $INSTALL_DIR

# install dive
REPO=wagoodman/dive
get_latest $REPO
curl --location \
  https://github.com/$REPO/releases/download/$TAG/dive_${VER}_linux_amd64.tar.gz | \
  tar xvfz - --directory $INSTALL_DIR

# install argocd
REPO=argoproj/argo-cd
get_latest $REPO
curl --location \
  --output $INSTALL_DIR/argocd \
  https://github.com/$REPO/releases/download/$TAG/argocd-linux-amd64 && \
  chmod 755 $INSTALL_DIR/argocd

# install pet
REPO=knqyf263/pet
get_latest $REPO
curl --location \
  https://github.com/$REPO/releases/download/$TAG/pet_${VER}_linux_amd64.tar.gz | \
  tar xvfz - --directory $INSTALL_DIR

# install rbac-lookup
REPO=FairwindsOps/rbac-lookup
get_latest $REPO
curl --location \
  https://github.com/$REPO/releases/download/$TAG/rbac-lookup_${VER}_Linux_x86_64.tar.gz | \
  tar xvfz - --directory $INSTALL_DIR

# install kubectl-tree
REPO=ahmetb/kubectl-tree
get_latest $REPO
curl --location \
  https://github.com/$REPO/releases/download/$TAG/kubectl-tree_${TAG}_linux_amd64.tar.gz | \
  tar xvfz - --directory $INSTALL_DIR

# install ketall aka kubectl-get-all
REPO=corneliusweig/ketall
get_latest $REPO
curl --location \
  https://github.com/$REPO/releases/download/$TAG/ketall-amd64-linux.tar.gz | \
  tar xvfz - --directory $INSTALL_DIR &&
  mv $INSTALL_DIR/ketall-amd64-linux $INSTALL_DIR/kubectl-get-all

# install kubectl-neat
REPO=itaysk/kubectl-neat
get_latest $REPO
curl --location \
  https://github.com/$REPO/releases/download/$TAG/kubectl-neat_linux.tar.gz | \
  tar xvfz - --directory $INSTALL_DIR

# install hey
curl --location \
  --output $INSTALL_DIR/hey \
  https://storage.googleapis.com/hey-release/hey_linux_amd64 && \
  chmod 755 $INSTALL_DIR/hey

# install kube-debug-pod
REPO=noseka1/kubectl-debugpod
get_latest $REPO
curl --location \
  https://github.com/$REPO/releases/download/$VER/kubectl-debugpod_${VER}_linux_amd64.tar.gz | \
  tar xvfz - --directory $INSTALL_DIR

# install istioctl
REPO=istio/istio
get_latest $REPO
curl --location \
  https://github.com/$REPO/releases/download/$VER/istioctl-$VER-linux-amd64.tar.gz |\
  tar xvfz - --directory $INSTALL_DIR

# install envoy (the same version that Istio is using)
VER=1.14.5
DOWNLOAD_URL=$(curl --location \
  https://tetrate.bintray.com/getenvoy/manifest.json \
  | jq --raw-output ".flavors.standard.versions.\"$VER\".builds.LINUX_GLIBC.downloadLocationUrl")
curl --location \
  $DOWNLOAD_URL | \
  tar xvfJ - --directory $INSTALL_DIR
mv $INSTALL_DIR/getenvoy-envoy-*/bin/envoy $INSTALL_DIR
rm -rf $INSTALL_DIR/getenvoy-envoy-*

# install MinIO client (S3 compatible client)
curl --location \
  --output $INSTALL_DIR/mc \
  https://dl.min.io/client/mc/release/linux-amd64/mc && \
  chmod 755 $INSTALL_DIR/mclient
