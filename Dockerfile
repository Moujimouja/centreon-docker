FROM centos:centos7
MAINTAINER egautier <gautier.eti@gmail.com>

# Update CentOS
RUN yum -y update

# Install Centreon Repository
RUN wget http://yum.centreon.com/standard/3.4/el7/stable/centreon-stable.repo /etc/yum.repo.d/

# Install ssh
RUN yum -y install openssh-server openssh-client
RUN mkdir /var/run/sshd
RUN echo 'root:centreon' | chpasswd
RUN sed -i 's/^#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config
RUN /etc/init.d/sshd start && /etc/init.d/sshd stop

# Install centreon
RUN yum -y install MariaDB-server && /etc/init.d/mysql start && yum -y install centreon centreon-base-config-centreon-engine centreon-installed centreon-clapi && /etc/init.d/mysql stop

# Install Widgets
RUN yum -y install centreon-widget-graph-monitoring centreon-widget-host-monitoring centreon-widget-service-monitoring centreon-widget-hostgroup-monitoring centreon-widget-servicegroup-monitoring
# Fix pass in db
ADD scripts/cbmod.sql /tmp/cbmod.sql
RUN /etc/init.d/mysql start && sleep 5 && mysql centreon < /tmp/cbmod.sql && /usr/bin/centreon -u admin -p centreon -a POLLERGENERATE -v 1 && /usr/bin/centreon -u admin -p centreon -a CFGMOVE -v 1 && /etc/init.d/mysql stop

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
