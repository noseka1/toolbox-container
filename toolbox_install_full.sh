#!/bin/bash

set -euo pipefail

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
. $script_dir/toolbox_install_common.sh

if type dnf > /dev/null 2>&1; then
  dnf install \
    --assumeyes \
    --setopt install_weak_deps=False \
    ansible \
    awscli \
    bat \
    buildah \
    fzf \
    kcat \
    podman \
    python3-kubernetes \
    python3-openshift \
    runc \
    skopeo \
    stress-ng \
    tmux \
    zsh
  dnf clean all
fi

# Install Terraform binary
ver=1.5.5
curl --location --no-progress-meter \
  https://releases.hashicorp.com/terraform/$ver/terraform_${ver}_linux_amd64.zip | \
  gunzip > $install_dir/terraform && \
  chmod 755 $install_dir/terraform

# Install cert-manager client
github_download_latest_asset cert-manager/cert-manager "cmctl-linux-amd64.tar.gz" | \
  tar xvfz - --directory $install_dir cmctl

# Install velero client (the velero client version should match the version deployed by the oadp operator)
github_download_latest_asset vmware-tanzu/velero "velero-.*-linux-amd64.tar.gz" | \
  tar xvfz - --directory $install_dir --strip-components=1 --wildcards velero-*-linux-amd64/velero

# Install dust
github_download_latest_asset bootandy/dust "dust-.*-x86_64-unknown-linux-gnu.tar.gz" | \
  tar xvfz - --directory $install_dir --strip-components=1 --wildcards dust-*-x86_64-unknown-linux-gnu/dust

# Install oc and kubectl
curl --location --no-progress-meter \
  https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz | \
  tar xvfz - --directory $install_dir oc kubectl && \
  kubectl completion bash > /etc/bash_completion.d/kubectl && \
  oc completion bash > /etc/bash_completion.d/oc

# Install oc-mirror plugin
curl --location --no-progress-meter \
  https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/oc-mirror.tar.gz | \
  tar xvfz - --directory $install_dir && \
  chmod 755 $install_dir/oc-mirror

# Install kubecolor
github_download_latest_asset hidetatz/kubecolor "kubecolor_.*_Linux_x86_64.tar.gz" | \
  tar xvfz - --directory $install_dir kubecolor

# Install etcd client
github_download_latest_asset etcd-io/etcd "etcd-.*-linux-amd64.tar.gz" | \
  tar xvfz - --directory $install_dir --strip-components=1 --no-same-owner --wildcards etcd-*-linux-amd64/etcdctl

# Install s2i
github_download_latest_asset openshift/source-to-image "source-to-image-.*-linux-amd64.tar.gz" | \
  tar xvfz - --directory $install_dir --strip-components=1

# Install noobaa
github_download_latest_asset noobaa/noobaa-operator "noobaa-operator-.*-linux-amd64.tar.gz$" | \
  tar xvfz - --directory $install_dir ./noobaa-operator

# Install helm
github_get_latest_asset helm/helm ""
curl --location --no-progress-meter \
  https://get.helm.sh/helm-${github_asset_tag}-linux-amd64.tar.gz | \
  tar xvfz - --directory $install_dir --strip-components=1 --no-same-owner linux-amd64/helm

# Install operator sdk
github_download_latest_asset operator-framework/operator-sdk "operator-sdk_linux_amd64" \
  > $install_dir/operator-sdk && \
  chmod 755 $install_dir/operator-sdk

# Install opm (operator package manager)
github_download_latest_asset operator-framework/operator-registry "linux-amd64-opm" \
  > $install_dir/opm && \
  chmod 755 $install_dir/opm

# Install kustomize
github_download_latest_asset kubernetes-sigs/kustomize "kustomize_.*_linux_amd64.tar.gz" | \
  tar xvfz - --directory $install_dir && \
  chmod 755 $install_dir/kustomize

# Install odo
curl --location --no-progress-meter \
  --output $install_dir/odo \
  https://mirror.openshift.com/pub/openshift-v4/clients/odo/latest/odo-linux-amd64 && \
  chmod 755 $install_dir/odo

# Install kn (serverless client)
github_download_latest_asset knative/client "kn-linux-amd64" \
  > $install_dir/kn && \
  chmod 755 $install_dir/kn

# Install tekton cli
github_download_latest_asset tektoncd/cli "tkn_.*_Linux_x86_64.tar.gz" | \
  tar xvfz - --directory $install_dir --no-same-owner tkn

# Install stern
github_download_latest_asset stern/stern "stern_.*_linux_amd64.tar.gz" | \
  tar xvfz - --directory $install_dir --no-same-owner stern && \
  chmod 755 $install_dir/stern

# Install kubens and kubectx
github_download_latest_asset ahmetb/kubectx "kubens_.*_linux_x86_64.tar.gz" | \
  tar xvfz - --directory $install_dir --no-same-owner kubens

github_download_latest_asset ahmetb/kubectx "kubectx_.*_linux_x86_64.tar.gz" | \
  tar xvfz - --directory $install_dir --no-same-owner kubectx

# Install fortio
github_download_latest_asset fortio/fortio "fortio-linux_amd64-.*.tgz" | \
  tar xvfz - --directory $install_dir --strip-components=2 usr/bin/fortio && \
  chmod 755 $install_dir/fortio

# Install lazygit
github_download_latest_asset jesseduffield/lazygit "lazygit_.*_Linux_x86_64.tar.gz" | \
  tar xvfz - --directory $install_dir lazygit && \
  chmod 755 $install_dir/lazygit

# Install gitmux
github_download_latest_asset arl/gitmux "gitmux_.*_linux_amd64.tar.gz" | \
  tar xvfz - --directory $install_dir gitmux

# Install dive
github_download_latest_asset wagoodman/dive "dive_.*_linux_amd64.tar.gz" | \
  tar xvfz - --directory $install_dir dive

# Install argocd
github_download_latest_asset argoproj/argo-cd "argocd-linux-amd64" \
  > $install_dir/argocd && \
  chmod 755 $install_dir/argocd

# Install argo rollouts client
github_download_latest_asset argoproj/argo-rollouts "kubectl-argo-rollouts-linux-amd64" \
  > $install_dir/kubectl-argo-rollouts && \
  chmod 755 $install_dir/kubectl-argo-rollouts

# Install navi
github_download_latest_asset denisidoro/navi "navi-v.*-x86_64-unknown-linux-musl.tar.gz" | \
  tar xvfz - --directory $install_dir

# Install rbac-lookup
github_download_latest_asset FairwindsOps/rbac-lookup "rbac-lookup_.*_Linux_x86_64.tar.gz" | \
  tar xvfz - --directory $install_dir rbac-lookup

# Install rbac-tool
github_download_latest_asset alcideio/rbac-tool "rbac-tool_.*_linux_amd64.tar.gz" | \
  tar xvfz - --directory $install_dir rbac-tool

# Install kubectl-tree
github_download_latest_asset ahmetb/kubectl-tree "kubectl-tree_.*_linux_amd64.tar.gz" | \
  tar xvfz - --directory $install_dir kubectl-tree

# Install ketall aka kubectl-get-all
github_download_latest_asset corneliusweig/ketall "ketall-amd64-linux.tar.gz$" | \
  tar xvfz - --directory $install_dir ketall-amd64-linux &&
  mv $install_dir/ketall-amd64-linux $install_dir/kubectl-get-all

# Install kubectl-neat
github_download_latest_asset itaysk/kubectl-neat "kubectl-neat_linux_amd64.tar.gz" | \
  tar xvfz - --directory $install_dir kubectl-neat

# Install kube-capacity
github_download_latest_asset robscott/kube-capacity "kube-capacity_.*_linux_x86_64.tar.gz" | \
  tar xvfz - --directory $install_dir kube-capacity

# Install oha
github_download_latest_asset hatoo/oha "oha-linux-amd64" \
  > $install_dir/oha && \
  chmod 755 $install_dir/oha

# Install kube-debugpod
github_download_latest_asset noseka1/kubectl-debugpod "kubectl-debugpod_.*_linux_amd64.tar.gz" | \
  tar xvfz - --directory $install_dir kubectl-debugpod

# Install istioctl
github_download_latest_asset istio/istio "istioctl-.*-linux-amd64.tar.gz$" | \
  tar xvfz - --directory $install_dir

# Install envoy (the same version that Istio is using)
ver=$(curl --location --no-progress-meter https://archive.tetratelabs.io/envoy/envoy-versions.json | jq --raw-output '.latestVersion')
download_url=https://archive.tetratelabs.io/envoy/download/v${ver}/envoy-v${ver}-linux-amd64.tar.xz
curl --location --no-progress-meter \
  $download_url | \
  tar xvfJ - --directory $install_dir --strip-components=2 envoy-v${ver}-linux-amd64/bin/envoy

# Install MinIO client (S3 compatible client)
curl --location --no-progress-meter \
  --output $install_dir/mclient \
  https://dl.min.io/client/mc/release/linux-amd64/mc && \
  chmod 755 $install_dir/mclient

# Install kubevirt cli
github_download_latest_asset kubevirt/kubevirt "virtctl-.*-linux-amd64" \
  > $install_dir/virtctl && \
  chmod 755 $install_dir/virtctl

# Install roxctl
curl --location --no-progress-meter \
  --output $install_dir/roxctl \
  https://mirror.openshift.com/pub/rhacs/assets/latest/bin/Linux/roxctl && \
  chmod 755 $install_dir/roxctl

# Install rosa CLI
github_download_latest_asset openshift/rosa rosa-linux-amd64 \
  > $install_dir/rosa && \
  chmod 755 $install_dir/rosa

# Install ocm CLI
github_download_latest_asset openshift-online/ocm-cli "ocm-linux-amd64" \
  > $install_dir/ocm && \
  chmod 755 $install_dir/ocm

# Install mirror-registry
curl --location --no-progress-meter \
  https://developers.redhat.com/content-gateway/rest/mirror2/pub/openshift-v4/clients/mirror-registry/latest/mirror-registry.tar.gz | \
  tar xvfz - --directory $install_dir

# Install tilt
github_download_latest_asset tilt-dev/tilt "tilt..*.linux.x86_64.tar.gz" | \
  tar xvfz - --directory $install_dir tilt

# Install skaffold
github_download_latest_asset GoogleContainerTools/skaffold "skaffold-linux-amd64" \
  > $install_dir/skaffold && \
  chmod 755 $install_dir/skaffold

# Install install butane
curl --location --no-progress-meter \
  --output $install_dir/butane \
  https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/butane/latest/butane-amd64 && \
  chmod 755 $install_dir/butane

# Install CoreOS installer
curl --location --no-progress-meter \
  --output $install_dir/coreos-installer \
  https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/coreos-installer/latest/coreos-installer_amd64 && \
  chmod 755 $install_dir/coreos-installer

# Install RHOAS (Red Hat OpenShift Application Services) CLI
github_download_latest_asset redhat-developer/app-services-cli "rhoas_.*_linux_amd64.tar.gz" | \
  tar xvfz - --directory $install_dir --strip-components=1 --wildcards rhoas_*_linux_amd64/rhoas

# Install OpenShift installer
curl --location --no-progress-meter \
  https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-install-linux.tar.gz | \
  tar xvfz - --directory $install_dir openshift-install

# Install OpenShift Local (formerly known as CodeReady Containers)
curl --location --no-progress-meter \
  https://developers.redhat.com/content-gateway/rest/mirror/pub/openshift-v4/clients/crc/latest/crc-linux-amd64.tar.xz | \
  tar xvfJ - --directory $install_dir --strip-components=1 --no-anchored --wildcards crc

# Install Cloud Credential Operator CLI utility
curl --location --no-progress-meter \
  https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/ccoctl-linux.tar.gz | \
  tar xvfz - --directory $install_dir ccoctl

# Install crane
github_download_latest_asset google/go-containerregistry "go-containerregistry_Linux_x86_64.tar.gz" | \
  tar xvfz - --directory $install_dir crane

# Install cosign
github_download_latest_asset sigstore/cosign "cosign-linux-amd64" \
  > $install_dir/cosign && \
  chmod 755 $install_dir/cosign

# Install skupper client
github_download_latest_asset skupperproject/skupper skupper-cli-.*-linux-amd64.tgz | \
  tar xvfz - --directory $install_dir skupper
