#!/bin/sh

set -e
set -x

service mysql start
httpd -k start

cd /usr/share/centreon/www/install/steps/process
cat ../../../../autoinstall.php installConfigurationDb.php | php
cat ../../../../autoinstall.php installStorageDb.php | php
cat ../../../../autoinstall.php createDbUser.php | php
cat ../../../../autoinstall.php insertBaseConf.php | php
cat ../../../../autoinstall.php configFileSetup.php | php
cat ../../../../autoinstall.php partitionTables.php | php



service mysql stop
httpd -k stop

