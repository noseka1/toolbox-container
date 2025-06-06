#!/bin/bash

# This script "improves" the web terminal instance by:
# Increasing the CPU and memory resource requests
# Mounting a persistent volume for the home directory

set -euo pipefail

# Obtain the script directory, see also:
# https://stackoverflow.com/questions/59895/how-to-get-the-source-directory-of-a-bash-script-from-within-the-script-itself/246128#246128
source="${BASH_SOURCE[0]}"
# Resolve $source until the file is no longer a symlink
while [ -h "$source" ]; do
  dir="$( cd -P "$( dirname "$source" )" >/dev/null 2>&1 && pwd )"
  source="$(readlink "$source")"
  # If $source was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  [[ $source != /* ]] && source="$dir/$source"
done
script_dir="$( cd -P "$( dirname "$source" )" >/dev/null 2>&1 && pwd )"

function usage() {
    echo "Usage: $0 [options...]"
    echo "-i, --image   Container image to use for web-terminal"
}

image=quay.io/noseka1/toolbox-container:term
while [ $# -gt 0 ];
do
  case $1 in
    --image|-i)
      shift
      image=$1
      ;;
    --help|-h)
      usage
      exit 1
      ;;
  esac
 shift
done

subscription_namespace=$(\
  oc get subscriptions.operators.coreos.com --all-namespaces --output json |
    jq --raw-output '.items[] | select(.spec.name=="web-terminal") | .metadata.namespace'
  )

sed \
  -e "s/@@DEVWORKSPACE_NAME@@/$DEVWORKSPACE_NAME/g" \
  -e "s#@@IMAGE@@#$image#g" \
  -e "s#@@SUBSCRIPTION_NAMESPACE@@#$subscription_namespace#g" \
  "$script_dir/devworkspace.yaml" | \
  oc apply -f -
