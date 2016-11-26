#!/bin/sh

set -e
set -x

service mysql start
httpd -k start

cd /usr/share/centreon/www/install/steps/process
cat /usr/share/centreon/autoinstall.php installConfigurationDb.php | php
cat /usr/share/centreon/autoinstall.php installStorageDb.php | php
cat /usr/share/centreon/autoinstall.php createDbUser.php | php
cat /usr/share/centreon/autoinstall.php insertBaseConf.php | php
cat /usr/share/centreon/autoinstall.php configFileSetup.php | php
cat /usr/share/centreon/autoinstall.php partitionTables.php | php
cd /tmp/
rm -rf /usr/share/centreon/www/install
mysql -e "GRANT ALL ON *.* to root@'%' IDENTIFIED BY 'centreon'"
mysql centreon < /tmp/cbmod.sql 
centreon -d -u admin -p centreon -a POLLERGENERATE -v 1
centreon -d -u admin -p centreon -a CFGMOVE -v 1

httpd -k stop
service mysql stop

