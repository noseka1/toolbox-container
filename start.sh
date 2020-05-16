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

echo
echo Press Ctrl-C to exit ...

# block here
trap : TERM INT
sleep infinity & wait
