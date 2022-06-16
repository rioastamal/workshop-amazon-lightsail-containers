#!/bin/bash
# This script intended to be run inside a container

export PYTHONPATH=/app/libs

# Run gunicorn WSGI server
[ -z "$APP_BIND" ] && APP_BIND='0.0.0.0:8080'
[ -z "$APP_WORKER" ] && APP_WORKER=4
$PYTHONPATH/bin/gunicorn \
 -w $APP_WORKER \
 -b $APP_BIND \
 --chdir /app/src 'index:app'
