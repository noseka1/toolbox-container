#!/bin/bash -x

dnf install \
  --assumeyes \
  --setopt install_weak_deps=False \
  git \
  jq \
  golang

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
. $script_dir/toolbox_install_common.sh

# build delve (Golang debugger)
repo=go-delve/delve
get_latest $repo
tmpdir=$(mktemp --directory --suffix -dlv)
(
  cd $tmpdir
  go mod init local/build
  go get github.com/go-delve/delve/cmd/dlv@$tag
  rm -rf $tmpdir
)
