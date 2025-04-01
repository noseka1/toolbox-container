#!/bin/bash
echo '
******************************************
* WELCOME TO TOOLBOX CONTAINER *
******************************************
'

echo OS: $(cat /etc/redhat-release)
echo Time: $(date)

echo '
******
* ID *
******
'

id

echo '
*********
* CAPSH *
*********
'

capsh --print

echo '
***************
* ENVIRONMENT *
***************
'

env

echo '
**********************
* NETWORK INTERFACES *
**********************
'

ip address

echo '
************************
* KUBERNETES API TOKEN *
************************
'

if [ -r /var/run/secrets/kubernetes.io/serviceaccount/token ]; then
  jq -R 'gsub("-";"+") | gsub("_";"/") | split(".") | .[1] | @base64d | fromjson' \
    /var/run/secrets/kubernetes.io/serviceaccount/token
else
  echo "No token found!"
fi

# Add toolbox user entry to /etc/passwd
/usr/local/bin/toolbox_fix_user.sh

# Execute an init script if provided
custom_init=/toolbox/init.sh
if [ -r $custom_init ]; then
  echo '
***********************
* CUSTOM INIT SCRIPT  *
***********************
'
  source $custom_init
  exit_code=$?
  echo
  echo Init script completed with exit code $exit_code
  if [ $exit_code -ne 0 ]; then
    exit $exit_code
  fi
fi

# If custom run script was provided, execute the run script
custom_run=/toolbox/run.sh
if [ -r $custom_run ]; then
  echo '
***********************
* CUSTOM RUN SCRIPT  *
***********************
'
  source $custom_run
  exit_code=$?
  echo
  echo Run script completed with exit code $exit_code
# Else if script arguments where provided, execute them
elif [ $# -gt 0 ]; then
  exec "$@"
# Else block waiting for signals
else
  echo
  echo Press Ctrl-C to exit ...

  trap : TERM INT
  sleep infinity & wait
fi
