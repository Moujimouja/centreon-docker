centreon-docker
===============

Trying to create a docker image for Centreon 2.8 on CentOS 7

Not working right now : see errors when building :

* Problem with base Centreon configuration installation
* Problem with Centreon Engine  :

```shell
 Installing : centreon-engine-daemon-1.6.1-1.el7.centos.x86_64         235/248
 error reading information on service centengine: No such file or directory
 Note: Forwarding request to 'systemctl enable centengine.service'.
 Configuration file /etc/systemd/system/centengine.service is marked executable. Please remove executable permission bits. Proceeding anyway.
 Configuration file /etc/systemd/system/centengine.service is marked executable. Please remove executable permission bits. Proceeding anyway.
 Created symlink from /etc/systemd/system/multi-user.target.wants/centengine.service to /etc/systemd/system/centengine.service.
```

 * Problem with Centreon Broker
 
```shell
 Installing : centreon-broker-cbd-3.0.1-1.el7.centos.x86_64            242/248
 error reading information on service cbd: No such file or directory
 Note: Forwarding request to 'systemctl enable cbd.service'.
 Configuration file /etc/systemd/system/cbd.service is marked executable. Please remove executable permission bits. Proceeding anyway.
 Configuration file /etc/systemd/system/cbd.service is marked executable. Please remove executable permission bits. Proceeding anyway.
 Created symlink from /etc/systemd/system/multi-user.target.wants/cbd.service to /etc/systemd/system/cbd.service.
```

* Probleme during centreon installed installation :

```shell
 Installing : centreon-installed-2.8.1-8.el7.centos.noarch             247/248
 Failed to get D-Bus connection: Operation not permitted
 Starting MySQL.161126 18:32:38 mysqld_safe Logging to '/var/lib/mysql/d6dcf178f680.err'.
 .[  OK  ]
 /var/tmp/rpm-tmp.iHFXCN: line 53: /usr/share/centreon/www/install/createNDODB.sql: No such file or directory
 ERROR 1452 (23000) at line 11: Cannot add or update a child row: a foreign key constraint fails (`centreon`.`contact`, CONSTRAINT `contact_ibfk_1` FOREIGN KEY (`timeperiod_tp_id`) REFERENCES `timeperiod` (`tp_id`) ON DELETE SET NULL)
 ERROR 1452 (23000) at line 3: Cannot add or update a child row: a foreign key constraint fails (`centreon`.`acl_group_contactgroups_relations`, CONSTRAINT `acl_group_contactgroups_relations_ibfk_1` FOREIGN KEY (`cg_cg_id`) REFERENCES `contactgroup` (`cg_id`) ON DELETE CASCADE)
```

