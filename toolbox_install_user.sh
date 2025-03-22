#!/bin/bash

set -euo pipefail

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
. $script_dir/toolbox_install_common.sh

# Install custom rcfiles
rcfiles_dir=~/git/github.com/noseka1/rcfiles
git clone https://github.com/noseka1/rcfiles $rcfiles_dir
$rcfiles_dir/bin/rcfiles_setup --assumeyes

# Skip compaudit. It doesn't like completion files owned by a different user.
# This is a problem when using this image for OpenShift web-terminal.
# See also https://stackoverflow.com/questions/13762280/zsh-compinit-insecure-directories
sed -i 's/^compinit$/compinit -u/' ~/.zshrc.in

# Replace absolute symlinks with relative ones so that the toolbox user's
# configuration files can be copied to another user's home directory
symlinks -rc ~

# Remove files with no group permissions (find . \! -perm /g+rwx)
rm -rf \
  ~/.cache \
  ~/.viminfo

# Set owner = toolbox, group = root for all files in toolbox's home directory
chown -R toolbox:root ~

# Make all files that are writeable by owner also writeable by (root) group
find ~ -perm -u+w -exec chmod g+w {} +
