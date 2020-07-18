#!/bin/bash -x

dnf install \
  --assumeyes \
  --setopt install_weak_deps=False \
  ansible \
  awscli \
  buildah \
  fzf \
  podman \
  runc \
  skopeo \
  the_silver_searcher \
  tmux

# install s2i
curl --location \
  https://github.com/openshift/source-to-image/releases/download/v1.3.0/source-to-image-v1.3.0-eed2850f-linux-amd64.tar.gz | \
  tar xvfz - --directory /usr/local/bin && \
  chmod 755 /usr/local/bin/s2i \
  chmod 755 /usr/local/bin

# install noobaa
curl --location \
  --output /usr/local/bin/noobaa \
  https://github.com/noobaa/noobaa-operator/releases/download/v2.2.0/noobaa-linux-v2.2.0 && \
  chmod 755 /usr/local/bin/noobaa

# install helm
curl --location \
  --output /usr/local/bin/helm \
  https://mirror.openshift.com/pub/openshift-v4/clients/helm/latest/helm-linux-amd64 && \
  chmod 755 /usr/local/bin/helm

# install operator sdk
curl --location \
  --output /usr/local/bin/operator-sdk \
  https://github.com/operator-framework/operator-sdk/releases/download/v0.19.0/operator-sdk-v0.19.0-x86_64-linux-gnu && \
  chmod 755 /usr/local/bin/operator-sdk

# install kustomize
curl --location \
  https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.8.0/kustomize_v3.8.0_linux_amd64.tar.gz | \
  tar xvfz - --directory /usr/local/bin && \
  chmod 755 /usr/local/bin/kustomize

# install odo
curl --location \
  --output /usr/local/bin/odo \
  https://mirror.openshift.com/pub/openshift-v4/clients/odo/latest/odo-linux-amd64 && \
  chmod 755 /usr/local/bin/odo

# install kn (serverless client)
curl --location \
  https://mirror.openshift.com/pub/openshift-v4/clients/serverless/latest/kn-linux-amd64-0.15.2.tar.gz | \
  tar xvfz - --directory /usr/local/bin && \
  chmod 755 /usr/local/bin/kn

# install tekton cli
rpm --install https://github.com/tektoncd/cli/releases/download/v0.10.0/tektoncd-cli-0.10.0_Linux-64bit.rpm

# install stern
curl --location \
  --output /usr/local/bin/stern \
  https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64 && \
  chmod 755 /usr/local/bin/stern

# install kubens and kubectx
curl --location \
  --output /usr/local/bin/kubens \
  https://github.com/ahmetb/kubectx/releases/download/v0.9.1/kubens && \
  chmod 755 /usr/local/bin/kubens && \
  curl --location \
  --output /usr/local/bin/kubectx \
  https://github.com/ahmetb/kubectx/releases/download/v0.9.1/kubectx && \
  chmod 755 /usr/local/bin/kubectx

# install fortio
rpm --install https://github.com/fortio/fortio/releases/download/v1.4.2/fortio-1.4.2-1.x86_64.rpm

# install lazygit
curl --location \
  https://github.com/jesseduffield/lazygit/releases/download/v0.20.6/lazygit_0.20.6_Linux_x86_64.tar.gz | \
  tar xvfz - --directory /usr/local/bin && \
  chmod 755 /usr/local/bin/lazygit

# install gitmux
curl --location \
  https://github.com/arl/gitmux/releases/download/v0.6.0/gitmux_0.6.0_linux_amd64.tar.gz | \
  tar xvfz - --directory /usr/local/bin

# install dive
dnf install \
  --assumeyes \
  --setopt install_weak_deps=False \
  https://github.com/wagoodman/dive/releases/download/v0.9.2/dive_0.9.2_linux_amd64.rpm

# install argocd
curl --location \
  --output /usr/local/bin/argocd \
  https://github.com/argoproj/argo-cd/releases/download/v1.6.1/argocd-linux-amd64 && \
  chmod 755 /usr/local/bin/argocd

# install pet
dnf install \
  --assumeyes \
  --setopt install_weak_deps=False \
  https://github.com/knqyf263/pet/releases/download/v0.3.6/pet_0.3.6_linux_amd64.rpm

# install rbac-lookup
curl --location \
  https://github.com/FairwindsOps/rbac-lookup/releases/download/v0.6.0/rbac-lookup_0.6.0_Linux_x86_64.tar.gz | \
  tar xvfz - --directory /usr/local/bin

# install kubectl-tree
curl --location \
  https://github.com/ahmetb/kubectl-tree/releases/download/v0.4.0/kubectl-tree_v0.4.0_linux_amd64.tar.gz | \
  tar xvfz - --directory /usr/local/bin

# install ketall
curl --location \
  https://github.com/corneliusweig/ketall/releases/download/v1.3.2/ketall-amd64-linux.tar.gz | \
  tar xvfz - --directory /usr/local/bin &&
  mv /usr/local/bin/ketall-amd64-linux /usr/local/bin/kubectl-get_all
