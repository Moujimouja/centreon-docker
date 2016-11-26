#!/bin/sh

set -e
set -x

service mysql start
httpd -k start

mysql -e "GRANT ALL ON *.* to root@'%' IDENTIFIED BY 'centreon'"


service mysql stop
httpd -k stop

