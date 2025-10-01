#!/bin/bash

set -euo pipefail

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
. $script_dir/toolbox_install_common.sh

if type dnf > /dev/null 2>&1; then
  dnf install \
    --assumeyes \
    --setopt install_weak_deps=False \
    bat \
    bc \
    dnsmasq \
    duf \
    fzf \
    haproxy \
    hexyl \
    httpd \
    lnav \
    nginx \
    nmstate \
    skopeo \
    tmux \
    zsh
  dnf clean all
fi

# Install auger (Kubernetes etcd analysis tool)
github_download_latest_asset etcd-io/auger "auger_.*_linux_amd64.tar.gz" | \
  tar xvfz - --directory $install_dir auger augerctl

# Install kubectl-mc (multi-cluster kubectl client)
github_download_latest_asset jonnylangefeld/kubectl-mc "kubectl-mc_v.*_linux_amd64.tar.gz" | \
  tar xvfz - --directory $install_dir kubectl-mc

# Install Loki logcli
github_download_latest_asset grafana/loki "logcli-linux-amd64.zip" | \
  gunzip > $install_dir/logcli && \
  chmod 755 $install_dir/logcli

# Install netobserv CLI
github_download_latest_asset netobserv/network-observability-cli "netobserv-cli.tar.gz" | \
  tar xvfz - --directory $install_dir --strip-components=2 --wildcards ./build/netobserv

# Install kopia
github_download_latest_asset kopia/kopia "kopia-.*-linux-x64.tar.gz" | \
  tar xvfz - --directory $install_dir --strip-components=1 --wildcards kopia-*-linux-x64/kopia

# Install cert-manager client
github_download_latest_asset cert-manager/cmctl "cmctl_linux_amd64" \
  > $install_dir/cmctl && \
  chmod 755 $install_dir/cmctl

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

# Install kubecolor
github_download_latest_asset kubecolor/kubecolor "kubecolor_.*_linux_amd64.tar.gz" | \
  tar xvfz - --directory $install_dir kubecolor

# Install etcd client
github_download_latest_asset etcd-io/etcd "etcd-.*-linux-amd64.tar.gz" | \
  tar xvfz - --directory $install_dir --strip-components=1 --no-same-owner --wildcards etcd-*-linux-amd64/etcdctl

# Install opm (operator package manager)
github_download_latest_asset operator-framework/operator-registry "linux-amd64-opm" \
  > $install_dir/opm && \
  chmod 755 $install_dir/opm

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

# Install Kubernetes context switcher
github_download_latest_asset danielfoehrKn/kubeswitch "switcher_linux_amd64" \
  > $install_dir/switcher && \
  chmod 755 $install_dir/switcher

# Install lazygit
github_download_latest_asset jesseduffield/lazygit "lazygit_.*_linux_x86_64.tar.gz" | \
  tar xvfz - --directory $install_dir lazygit && \
  chmod 755 $install_dir/lazygit

# Install gitmux
github_download_latest_asset arl/gitmux "gitmux_.*_linux_amd64.tar.gz" | \
  tar xvfz - --directory $install_dir gitmux

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
github_download_latest_asset corneliusweig/ketall "ketall-amd64-linux.tar.gz" | \
  tar xvfz - --directory $install_dir ketall-amd64-linux &&
  mv $install_dir/ketall-amd64-linux $install_dir/kubectl-get-all

# Install kubectl-neat
github_download_latest_asset itaysk/kubectl-neat "kubectl-neat_linux_amd64.tar.gz" | \
  tar xvfz - --directory $install_dir kubectl-neat

# Install kube-capacity
github_download_latest_asset robscott/kube-capacity "kube-capacity_.*_linux_x86_64.tar.gz" | \
  tar xvfz - --directory $install_dir kube-capacity

# Install kube-debugpod
github_download_latest_asset noseka1/kubectl-debugpod "kubectl-debugpod_.*_linux_amd64.tar.gz" | \
  tar xvfz - --directory $install_dir kubectl-debugpod

# Install MinIO client (S3 compatible client)
curl --location --no-progress-meter \
  --output $install_dir/mcli \
  https://dl.min.io/client/mc/release/linux-amd64/mc && \
  chmod 755 $install_dir/mcli

# Install kubevirt cli
github_download_latest_asset kubevirt/kubevirt "virtctl-.*-linux-amd64" \
  > $install_dir/virtctl && \
  chmod 755 $install_dir/virtctl

# Install roxctl
curl --location --no-progress-meter \
  --output $install_dir/roxctl \
  https://mirror.openshift.com/pub/rhacs/assets/latest/bin/Linux/roxctl && \
  chmod 755 $install_dir/roxctl

# Install crane
github_download_latest_asset google/go-containerregistry "go-containerregistry_Linux_x86_64.tar.gz" | \
  tar xvfz - --directory $install_dir crane

# Install oras client
github_download_latest_asset oras-project/oras "oras_.*_linux_amd64.tar.gz" | \
  tar xvfz - --directory $install_dir --no-same-owner oras

# Install oha
github_download_latest_asset hatoo/oha "oha-linux-amd64" \
  > $install_dir/oha && \
  chmod 755 $install_dir/oha
