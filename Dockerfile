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


# Install ssh
RUN yum -y install openssh-server openssh-client
RUN mkdir /var/run/sshd
RUN echo 'root:centreon' | chpasswd
RUN sed -i 's/^#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config
#Not working RUN service sshd start && service sshd stop https://github.com/CentOS/sig-cloud-instance-images/issues/28

# Install centreon
RUN yum -y --nogpgcheck install MariaDB-server 
RUN yum install --nogpgcheck -y centreon-base-config-centreon-engine centreon-broker* git
RUN echo 'date.timezone = Europe/Paris' > /etc/php.d/centreon.ini


# Create base Centreon configuration
ADD scripts/cbmod.sql /tmp/cbmod.sql
ADD scripts/install-db.sh /tmp/install-db.sh
ADD scripts/autoinstall.php /usr/share/centreon/autoinstall.php
RUN chmod +x /tmp/install-db.sh
RUN /tmp/install-db.sh

# Install Widgets
RUN yum -y install centreon-widget-graph-monitoring centreon-widget-host-monitoring centreon-widget-service-monitoring centreon-widget-hostgroup-monitoring centreon-widget-servicegroup-monitoring


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
