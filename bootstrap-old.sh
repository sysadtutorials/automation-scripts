#!/bin/bash

#####
echo -e "[INFO] Installing vim editor"
    yum install -y vim
    sleep 3
echo -e "\n"

echo -e "[INFO] Installing the epel-release"
    yum install -y epel-release
    sleep 3
echo -e "\n"

echo -e "[INFO] Updating the system"
    yum update -y
    sleep 3
echo -e "\n"

echo -e "[INFO] Installing httpd"
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    sleep 3
echo -e "\n"

echo -e "[INFO] Allowing http and https on firewalld"
    firewall-cmd --zone=public --permanent --add-service=http
    firewall-cmd --zone=public --permanent --add-service=https
    firewall-cmd --reload
    sleep 3
echo -e "\n"

echo -e "[INFO] Installing php5.4"
    yum install -y php php-fpm php-mysql
    sleep 3
echo -e "\n"

echo -e "[INFO] Installing mariadb-server"
    yum install -y mariadb mariadb-server
    firewall-cmd --zone=public --permanent --add-port=3306/tcp
    firewall-cmd --reload
    systemctl start mariadb
    systemctl enable mariadb
    sleep 3
echo -e "\n"

echo -e "[INFO] Installing fail2ban"
    yum install -y fail2ban fail2ban-firewalld fail2ban-systemd
    systemctl start fail2ban
    systemctl enable fail2ban
    sleep 3
echo -e "\n"

