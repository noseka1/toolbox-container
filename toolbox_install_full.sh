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
    kcat \
    python3-kubernetes \
    python3-openshift \
  dnf clean all
fi

# Install Terraform binary
ver=1.9.4
curl --location --no-progress-meter \
  https://releases.hashicorp.com/terraform/$ver/terraform_${ver}_linux_amd64.zip \
  > /tmp/terraform.zip
unzip /tmp/terraform.zip terraform -d $install_dir
rm /tmp/terraform.zip

# Install operator sdk
github_download_latest_asset operator-framework/operator-sdk "operator-sdk_linux_amd64" \
  > $install_dir/operator-sdk && \
  chmod 755 $install_dir/operator-sdk

# Install odo
curl --location --no-progress-meter \
  --output $install_dir/odo \
  https://mirror.openshift.com/pub/openshift-v4/clients/odo/latest/odo-linux-amd64 && \
  chmod 755 $install_dir/odo

# Install kn (serverless client)
github_download_latest_asset knative/client "kn-linux-amd64" \
  > $install_dir/kn && \
  chmod 755 $install_dir/kn

# Install fortio
github_download_latest_asset fortio/fortio "fortio-linux_amd64-.*.tgz" | \
  tar xvfz - --directory $install_dir --strip-components=2 usr/bin/fortio && \
  chmod 755 $install_dir/fortio

# Install dive
github_download_latest_asset wagoodman/dive "dive_.*_linux_amd64.tar.gz" | \
  tar xvfz - --directory $install_dir dive

# Install mirror-registry
curl --location --no-progress-meter \
  https://mirror.openshift.com/pub/cgw/mirror-registry/latest/mirror-registry-amd64.tar.gz | \
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

# Install RHOAS (Red Hat OpenShift Application Services) CLI
github_download_latest_asset redhat-developer/app-services-cli "rhoas_.*_linux_amd64.tar.gz" | \
  tar xvfz - --directory $install_dir --strip-components=1 --wildcards rhoas_*_linux_amd64/rhoas

# Install CoreOS installer
curl --location --no-progress-meter \
  --output $install_dir/coreos-installer \
  https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/coreos-installer/latest/coreos-installer_amd64 && \
  chmod 755 $install_dir/coreos-installer

# Install OpenShift installer
curl --location --no-progress-meter \
  https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-install-linux.tar.gz | \
  tar xvfz - --directory $install_dir openshift-install

# Install OpenShift Local (formerly known as CodeReady Containers)
curl --location --no-progress-meter \
  https://developers.redhat.com/content-gateway/rest/mirror/pub/openshift-v4/clients/crc/latest/crc-linux-amd64.tar.xz | \
  tar xvfJ - --directory $install_dir --strip-components=1 --no-anchored --wildcards crc
