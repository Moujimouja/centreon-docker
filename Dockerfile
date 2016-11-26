FROM centos:centos7
MAINTAINER egautier <gautier.eti@gmail.com>

# Update CentOS
RUN yum -y update
RUN yum install -y wget

# Install initscript to be able to use service command ( https://github.com/CentOS/sig-cloud-instance-images/issues/28 ) 
RUN yum -y install initscripts && yum clean all

# Install Centreon Repository
RUN wget http://yum.centreon.com/standard/3.4/el7/stable/centreon-stable.repo 
RUN mv centreon-stable.repo /etc/yum.repos.d/centreon-stable.repo

#Install Centreon GPG key
RUN wget http://yum.centreon.com/standard/3.4/el6/stable/RPM-GPG-KEY-CES 
RUN mv RPM-GPG-KEY-CES /etc/pki/rpm-gpg/RPM-GPG-KEY-CES

#Install MariaDB key
RUN wget https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
RUN mv RPM-GPG-KEY-MariaDB /etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB


# Install ssh
RUN yum -y install openssh-server openssh-client
RUN mkdir /var/run/sshd
RUN echo 'root:centreon' | chpasswd
RUN sed -i 's/^#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config
#Not working RUN service sshd start && service sshd stop https://github.com/CentOS/sig-cloud-instance-images/issues/28

# Install centreon
RUN yum -y --nogpgcheck install MariaDB-server 
RUN yum -y install centreon centreon-base-config-centreon-engine centreon-installed centreon-clapi


# Install Widgets
RUN yum -y install centreon-widget-graph-monitoring centreon-widget-host-monitoring centreon-widget-service-monitoring centreon-widget-hostgroup-monitoring centreon-widget-servicegroup-monitoring
# Fix pass in db
ADD scripts/cbmod.sql /tmp/cbmod.sql

#Obliged to make it 1 line http://stackoverflow.com/questions/25920029/setting-up-mysql-and-importing-dump-within-dockerfile
RUN /bin/bash -c "/usr/bin/mysqld_safe &" && \
mysql centreon < /tmp/cbmod.sql && \
 /usr/bin/centreon -u admin -p centreon -a POLLERGENERATE -v 1 && /usr/bin/centreon -u admin -p centreon -a CFGMOVE -v 1


# Set rights for setuid
RUN chown root:centreon-engine /usr/lib/nagios/plugins/check_icmp
RUN chmod -w /usr/lib/nagios/plugins/check_icmp
RUN chmod u+s /usr/lib/nagios/plugins/check_icmp

# Install and configure supervisor
RUN yum -y install python-setuptools
RUN easy_install supervisor

# Todo better split file
ADD scripts/supervisord.conf /etc/supervisord.conf

# Expose port SSH and HTTP for the service
EXPOSE 22 80

CMD ["/usr/bin/supervisord","--configuration=/etc/supervisord.conf"]
