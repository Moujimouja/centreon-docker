#!/bin/sh

#set -e
set -x

service mysql start > /dev/null ; echo $?

while true ; do
  retval=`mysql centreon -e 'SELECT * FROM nagios_server' > /dev/null ; echo $?`
  if [ "$retval" = 0 ] ; then
    break ;
  else
    echo 'DB server is not yet available.'
    sleep 1
  fi
done
service cbd start
service centengine start
su - centreon -c centcore &
service httpd stop > /dev/null ; echo $?
# Fix to allow Centreon Web to use our special init.d script and not
# call this cumbersome init system.
rm -rf /etc/systemd
tailf /var/log/httpd/error_log