#!/usr/bin/env bash
#Tested with Centos 6.x
#Trace execution
set -o xtrace
# Install MySQL
function installMySQL
{
yum install mysql mysql-server
/etc/init.d/mysql start
chkconfig --levels 35 mysqld on
# replace newpass by your password
mysqladmin -u root password newpass
}

function installHTTPD
{
yum install httpd
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
yum install php
# install php-mysql package
yum install php-mysql
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

