#!/bin/bash -x

dnf install \
  --assumeyes \
  --setopt install_weak_deps=False \
  git \
  jq \
  golang

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
. $SCRIPT_DIR/toolbox_install_common.sh

# build delve (Golang debugger)
REPO=go-delve/delve
get_latest $REPO
TMPDIR=$(mktemp --directory --suffix -dlv)
(
  cd $TMPDIR
  go mod init local/build
  go get github.com/go-delve/delve/cmd/dlv@$TAG
  rm -rf $TMPDIR
)
