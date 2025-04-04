#!/bin/bash

set -euo pipefail

# Add toolbox user entry to /etc/passwd
/usr/local/bin/toolbox_fix_user.sh

# If a persistent volume was mounted on the home directory
# initialize the home directory from the tarball
if mountpoint --quiet $HOME; then
  if [ ! -f $HOME/home_init_complete ]; then
    tar xfJ /home/toolbox.tar.xz -C $HOME
    touch $HOME/home_init_complete
  fi
fi

exec "$@"
