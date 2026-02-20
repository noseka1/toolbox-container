#!/bin/bash

echo Hello from the custom run script!

gunicorn-3 --bind 0.0.0.0:8080 --access-logfile - httpbin:app
