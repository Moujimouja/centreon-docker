#!/bin/sh

set -e
set -x

service mysql start
httpd -k start

service mysql stop
httpd -k stop

