#!/bin/bash -x

set -euo pipefail

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
. $script_dir/toolbox_install_common.sh

dnf install \
  --assumeyes \
  --setopt install_weak_deps=False \
  git \
  jq \
  golang

# build delve (Golang debugger)
repo=go-delve/delve
get_latest $repo
go install github.com/go-delve/delve/cmd/dlv@$tag
