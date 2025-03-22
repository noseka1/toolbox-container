#!/bin/bash

set -euo pipefail

# Update toolbox user entry in /etc/passwd.
# This script can be invoked from inside a running container in OpenShift.

if ! whoami &> /dev/null; then
  # Can't use sed -i due to permissions on /etc
  tmppasswd=$(sed "s#toolbox:.*#toolbox:x:$(id -u):0:Toolbox user:/home/toolbox:/bin/zsh#" /etc/passwd)
  echo "$tmppasswd" > /etc/passwd
fi
