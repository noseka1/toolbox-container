#!/bin/bash

set -euo pipefail

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
. $script_dir/toolbox_install_common.sh

# Install custom rcfiles
rcfiles_dir=~/git/github.com/noseka1/rcfiles
git clone https://github.com/noseka1/rcfiles $rcfiles_dir
$rcfiles_dir/bin/rcfiles_setup --assumeyes

# Replace absolute symlinks with relative ones so that the toolbox user's
# configuration files can be copied to another user's home directory
symlinks -rc ~

# Remove files with no group permissions (find . \! -perm /g+rwx)
rm -rf \
  ~toolbox/.bash_history \
  ~toolbox/.cache \
  ~toolbox/.viminfo

# All files in toolbox's home directory should be owned by toolbox
chown -R toolbox:root ~toolbox
