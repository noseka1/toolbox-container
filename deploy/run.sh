#!/bin/bash

echo Hello from the custom run script!

#python3 -m http.server 8080

#gunicorn-3 --bind 0.0.0.0:8080 --access-logfile - httpbin:app

echo
echo Press Ctrl-C to exit ...

trap : TERM INT
sleep infinity & wait
