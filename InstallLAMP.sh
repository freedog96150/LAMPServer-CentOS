#!/usr/bin/env bash
#Tested with Centos 6.x
#Trace execution
set -o xtrace
# Install MySQL
function installMySQL
{
yum -y install mysql mysql-server
/etc/init.d/mysqld start
chkconfig --levels 35 mysqld on
# replace newpass by your password
/usr/bin/mysqladmin -u root -h `hostname` password 'newpass'
/usr/bin/mysqladmin -u root -h localhost password 'newpass'
}

function installHTTPD
{
yum -y install httpd
/etc/init.d/httpd start
chkconfig --levels 35 httpd on
# Now browse IP of server to see test page
# if it hangs remove firewall
# iptables -F
# chkconfig iptables off
# or allow  port 80
}

function installPHP
{
#install PHP packages
yum -y install php
# install php-mysql package
yum -y install php-mysql
#restart httpd
/etc/init.d/httpd start
}
function configureFirewall
{
#restore iptables from old config
iptables-restore /etc/sysconfig/iptables.old
#add the httpd port 80
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
# This ensures you don't lock yourself out
# ssh if working remotely
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
#Save new config
service iptables save
#Restart firewall
/etc/init.d/iptables restart
}

installHTTPD
installMySQL
installPHP
configureFirewall

# Now go ahead and configure virtualhosts
# Test php with: php -r "phpinfo();"

