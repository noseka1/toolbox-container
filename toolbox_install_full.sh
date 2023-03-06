#!/bin/bash -x

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
    tmux
  dnf clean all
fi

# Install cert-manager client
repo=cert-manager/cert-manager
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/cmctl-linux-amd64.tar.gz | \
  tar xvfz - --directory $install_dir cmctl

# Install velero client (the velero client version should match the version deployed by the oadp operator)
repo=vmware-tanzu/velero
tag=v1.9.0
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/velero-${tag}-linux-amd64.tar.gz | \
  tar xvfz - --directory $install_dir --strip-components=1 velero-${tag}-linux-amd64/velero

# Install dust
repo=bootandy/dust
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/dust-${tag}-x86_64-unknown-linux-gnu.tar.gz | \
  tar xvfz - --directory $install_dir --strip-components=1 dust-${tag}-x86_64-unknown-linux-gnu/dust

# Install oc and kubectl
curl --location \
  https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz | \
  tar xvfz - --directory $install_dir oc kubectl && \
  kubectl completion bash > /etc/bash_completion.d/kubectl && \
  oc completion bash > /etc/bash_completion.d/oc

# Install oc-mirror plugin
curl --location \
  https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/oc-mirror.tar.gz | \
  tar xvfz - --directory $install_dir && \
  chmod 755 $install_dir/oc-mirror

# Install kubecolor
repo=hidetatz/kubecolor
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/kubecolor_${ver}_Linux_x86_64.tar.gz | \
  tar xvfz - --directory $install_dir kubecolor

# Install etcd client
repo=etcd-io/etcd
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/etcd-$tag-linux-amd64.tar.gz | \
  tar xvfz - --directory $install_dir --strip-components=1 --no-same-owner etcd-$tag-linux-amd64/etcdctl

# Install s2i
"${githubget[@]}" \
  https://github.com/openshift/source-to-image/releases/download/v1.3.1/source-to-image-v1.3.1-a5a77147-linux-amd64.tar.gz | \
  tar xvfz - --directory $install_dir --strip-components=1

# Install noobaa
repo=noobaa/noobaa-operator
get_latest $repo
"${githubget[@]}" \
  --output $install_dir/noobaa \
  https://github.com/$repo/releases/download/$tag/noobaa-linux-$tag && \
  chmod 755 $install_dir/noobaa

# Install helm
repo=helm/helm
get_latest $repo
curl --location \
  https://get.helm.sh/helm-$tag-linux-amd64.tar.gz | \
  tar xvfz - --directory $install_dir --strip-components=1 --no-same-owner linux-amd64/helm

# Install operator sdk
repo=operator-framework/operator-sdk
get_latest $repo
"${githubget[@]}" \
  --output $install_dir/operator-sdk \
  https://github.com/$repo/releases/download/$tag/operator-sdk_linux_amd64 && \
  chmod 755 $install_dir/operator-sdk

# Install opm (operator package manager)
repo=operator-framework/operator-registry
get_latest $repo
"${githubget[@]}" \
  --output $install_dir/opm \
  https://github.com/$repo/releases/download/$tag/linux-amd64-opm && \
  chmod 755 $install_dir/opm

# Install kustomize
repo=kubernetes-sigs/kustomize
tag=v4.2.0
ver=4.2.0
"${githubget[@]}" \
  https://github.com/$repo/releases/download/kustomize/$tag/kustomize_${tag}_linux_amd64.tar.gz | \
  tar xvfz - --directory $install_dir && \
  chmod 755 $install_dir/kustomize

# Install odo
curl --location \
  --output $install_dir/odo \
  https://mirror.openshift.com/pub/openshift-v4/clients/odo/latest/odo-linux-amd64 && \
  chmod 755 $install_dir/odo

# Install kn (serverless client)
curl --location \
  https://mirror.openshift.com/pub/openshift-v4/clients/serverless/latest/kn-linux-amd64.tar.gz | \
  tar xvfz - --directory $install_dir && \
  chmod 755 $install_dir/kn

# Install tekton cli
repo=tektoncd/cli
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/tkn_${ver}_Linux_x86_64.tar.gz | \
  tar xvfz - --directory $install_dir --no-same-owner tkn

# Install stern
repo=stern/stern
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/stern_${ver}_linux_amd64.tar.gz | \
  tar xvfz - --directory $install_dir --no-same-owner stern && \
  chmod 755 $install_dir/stern

# Install kubens and kubectx
repo=ahmetb/kubectx
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/kubens_${tag}_linux_x86_64.tar.gz | \
  tar xvfz - --directory $install_dir --no-same-owner kubens
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/kubectx_${tag}_linux_x86_64.tar.gz | \
  tar xvfz - --directory $install_dir --no-same-owner kubectx

# Install fortio
repo=fortio/fortio
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/fortio-linux_x64-$ver.tgz | \
  tar xvfz - --directory $install_dir --strip-components=2 usr/bin/fortio && \
  chmod 755 $install_dir/fortio

# Install lazygit
repo=jesseduffield/lazygit
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/lazygit_${ver}_Linux_x86_64.tar.gz | \
  tar xvfz - --directory $install_dir lazygit && \
  chmod 755 $install_dir/lazygit

# Install gitmux
repo=arl/gitmux
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/gitmux_${tag}_linux_amd64.tar.gz | \
  tar xvfz - --directory $install_dir

# Install dive
repo=wagoodman/dive
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/dive_${ver}_linux_amd64.tar.gz | \
  tar xvfz - --directory $install_dir dive

# Install argocd
repo=argoproj/argo-cd
get_latest $repo
"${githubget[@]}" \
  --output $install_dir/argocd \
  https://github.com/$repo/releases/download/$tag/argocd-linux-amd64 && \
  chmod 755 $install_dir/argocd

# Install argo rollouts client
"${githubget[@]}" \
  --output $install_dir/kubectl-argo-rollouts \
  https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64 && \
  chmod 755 $install_dir/kubectl-argo-rollouts

# Install pet
repo=knqyf263/pet
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/pet_${ver}_linux_amd64.tar.gz | \
  tar xvfz - --directory $install_dir pet

# Install rbac-lookup
repo=FairwindsOps/rbac-lookup
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/rbac-lookup_${ver}_Linux_x86_64.tar.gz | \
  tar xvfz - --directory $install_dir rbac-lookup

# Install rbac-tool
repo=alcideio/rbac-tool
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/rbac-tool_${tag}_linux_amd64.tar.gz | \
  tar xvfz - --directory $install_dir rbac-tool

# Install kubectl-tree
repo=ahmetb/kubectl-tree
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/kubectl-tree_${tag}_linux_amd64.tar.gz | \
  tar xvfz - --directory $install_dir

# Install ketall aka kubectl-get-all
repo=corneliusweig/ketall
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/ketall-amd64-linux.tar.gz | \
  tar xvfz - --directory $install_dir kubectl-get-all &&
  mv $install_dir/ketall-amd64-linux $install_dir/kubectl-get-all

# Install kubectl-neat
repo=itaysk/kubectl-neat
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/kubectl-neat_linux_amd64.tar.gz | \
  tar xvfz - --directory $install_dir

# Install hey
curl --location \
  --output $install_dir/hey \
  https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64 && \
  chmod 755 $install_dir/hey

# Install kube-debugpod
repo=noseka1/kubectl-debugpod
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$ver/kubectl-debugpod_${ver}_linux_amd64.tar.gz | \
  tar xvfz - --directory $install_dir kubectl-debugpod

# Install istioctl
repo=istio/istio
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$ver/istioctl-$ver-linux-amd64.tar.gz |\
  tar xvfz - --directory $install_dir

# Install envoy (the same version that Istio is using)
ver=$(curl --location --silent https://archive.tetratelabs.io/envoy/envoy-versions.json | jq --raw-output '.latestVersion')
download_url=https://archive.tetratelabs.io/envoy/download/v${ver}/envoy-v${ver}-linux-amd64.tar.xz
curl --location \
  $download_url | \
  tar xvfJ - --directory $install_dir
mv $install_dir/envoy-v${ver}-linux-amd64/bin/envoy $install_dir
rm -rf $install_dir/envoy-v${ver}-linux-amd64

# Install MinIO client (S3 compatible client)
curl --location \
  --output $install_dir/mclient \
  https://dl.min.io/client/mc/release/linux-amd64/mc && \
  chmod 755 $install_dir/mclient

# Install kubevirt cli
repo=kubevirt/kubevirt
tag=v0.59.0
ver=0.59.0
"${githubget[@]}" \
  --output $install_dir/virtctl \
  https://github.com/$repo/releases/download/$tag/virtctl-${tag}-linux-amd64
  chmod 755 $install_dir/virtctl

# Install roxctl
curl --location \
  --output $install_dir/roxctl \
  https://mirror.openshift.com/pub/rhacs/assets/latest/bin/Linux/roxctl && \
  chmod 755 $install_dir/roxctl

# Install rosa CLI
repo=openshift/rosa
get_latest $repo
"${githubget[@]}" \
  --output $install_dir/rosa \
  https://github.com/$repo/releases/download/$tag/rosa-linux-amd64 && \
  chmod 755 $install_dir/rosa

# Install ocm CLI
repo=openshift-online/ocm-cli
get_latest $repo
"${githubget[@]}" \
  --output $install_dir/ocm \
  https://github.com/$repo/releases/download/$tag/ocm-linux-amd64 && \
  chmod 755 $install_dir/ocm

# Install mirror-registry
curl --location \
  https://developers.redhat.com/content-gateway/rest/mirror2/pub/openshift-v4/clients/mirror-registry/latest/mirror-registry.tar.gz | \
  tar xvfz - --directory $install_dir

# Install tilt
repo=tilt-dev/tilt
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/tilt.${ver}.linux.x86_64.tar.gz | \
  tar xvfz - --directory $install_dir tilt

# Install skaffold
repo=GoogleContainerTools/skaffold
get_latest $repo
"${githubget[@]}" \
  --output $install_dir/skaffold \
  https://github.com/$repo/releases/download/$tag/skaffold-linux-amd64 && \
  chmod 755 $install_dir/skaffold

# Install install butane
curl --location \
  --output $install_dir/butane \
  https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/butane/latest/butane-amd64 && \
  chmod 755 $install_dir/butane

# Install CoreOS installer
curl --location \
  --output $install_dir/coreos-installer \
  https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/coreos-installer/latest/coreos-installer_amd64 && \
  chmod 755 $install_dir/coreos-installer

# Install RHOAS (Red Hat OpenShift Application Services) CLI
repo=redhat-developer/app-services-cli
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/rhoas_${ver}_linux_amd64.tar.gz | \
  tar xvfz - --directory $install_dir --strip-components=1 rhoas_${ver}_linux_amd64/rhoas

# Install OpenShift installer
curl --location \
  https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-install-linux.tar.gz | \
  tar xvfz - --directory $install_dir openshift-install

# Install OpenShift Local (formerly known as CodeReady Containers)
curl --location \
  https://developers.redhat.com/content-gateway/rest/mirror/pub/openshift-v4/clients/crc/latest/crc-linux-amd64.tar.xz | \
  tar xvfJ - --directory $install_dir --strip-components=1 --no-anchored --wildcards crc

# Install Cloud Credential Operator CLI utility
curl --location \
  https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/ccoctl-linux.tar.gz | \
  tar xvfz - --directory $install_dir ccoctl

# Install crane
repo=google/go-containerregistry
get_latest $repo
"${githubget[@]}" \
  https://github.com/$repo/releases/download/$tag/go-containerregistry_Linux_x86_64.tar.gz | \
  tar xvfz - --directory $install_dir crane

# Install cosign
repo=sigstore/cosign
get_latest $repo
"${githubget[@]}" \
  --output $install_dir/cosign \
  https://github.com/sigstore/cosign/releases/download/$tag/cosign-linux-amd64 && \
  chmod 755 $install_dir/cosign
