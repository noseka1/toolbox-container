#!/bin/bash
echo '
******************************************
* WELCOME TO OPENSHIFT-TOOLBOX CONTAINER *
******************************************
'

cat /etc/redhat-release

echo '
******
* ID *
******
'

id

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

CUSTOM_INIT=/toolbox/init.sh
if [ -r $CUSTOM_INIT ]; then
  echo '
***********************
* CUSTOM INIT SCRIPT  *
***********************
'
  source $CUSTOM_INIT
  EXIT_CODE=$?
  echo
  echo Init script completed with exit code $EXIT_CODE
  if [ $EXIT_CODE -ne 0 ]; then
    exit $EXIT_CODE
  fi
fi

CUSTOM_RUN=/toolbox/run.sh
if [ -r $CUSTOM_RUN ]; then
  echo '
***********************
* CUSTOM RUN SCRIPT  *
***********************
'
  source $CUSTOM_RUN
  EXIT_CODE=$?
  echo
  echo Run script completed with exit code $EXIT_CODE
else
  echo
  echo Press Ctrl-C to exit ...

  # block here
  trap : TERM INT
  sleep infinity & wait
fi
