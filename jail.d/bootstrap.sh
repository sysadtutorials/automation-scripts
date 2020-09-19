#!/bin/bash
################################################################################
#                              scriptTemplate                                  #
#                                                                              #
# Use this template as the setting up our server. This script will install     #
# httpd, php, mariadb, fail2ban                                                #
#                                                                              #
#                                                                              #
#                                                                              #
################################################################################
################################################################################
################################################################################
#                                                                              #
#  Copyright (C) 2020                                                          #
#                                                         #
#                                                                              #
#  This program is free software; you can redistribute it and/or modify        #
#  it under the terms of the GNU General Public License as published by        #
#  the Free Software Foundation; either version 2 of the License, or           #
#  (at your option) any later version.                                         #
#                                                                              #
#  This program is distributed in the hope that it will be useful,             #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of              #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               #
#  GNU General Public License for more details.                                #
#                                                                              #
#  You should have received a copy of the GNU General Public License           #
#  along with this program; if not, write to the Free Software                 #
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA   #
#                                                                              #
################################################################################
################################################################################
################################################################################

date=`date +%m-%d-%Y-%T`

function install_additionals {
    echo -e "################################################################################"
    echo -e "[INFO: ${date}] Installing additionals" 
        yum update -y
            sleep 3
        yum install -y epel-release
            sleep 3
        yum install -y git
            sleep 3
    echo -e "################################################################################\n"
}

function install_httpd {
    echo -e "################################################################################"
    echo -e "[INFO: ${date}] Installing httpd"
        yum install -y httpd
            sleep 3
    echo -e "[INFO: ${date}] Staring httpd"
        systemctl start httpd
            sleep 3
    echo -e "[INFO: ${date}] Enabling httpd to start on boot"
        systemctl enable httpd
            sleep 3
        echo -e "[INFO: ${date}] Checking httpd process if running....."
            if pgrep httpd > /dev/null 2>&1; then
                echo "[INFO: ${date}] httpd is running....."
            else
                echo "[INFO: ${date}] httpd is stopped....."
                echo "[INFO: ${date}] starting httpd service"
                    systemctl start httpd
                    sleep 3
                echo "[INFO: ${date}] httpd is started....."
            fi
    echo -e "################################################################################\n"
}

function install_php {
    echo -e "################################################################################"
    echo -e "[INFO: ${date}] Installing php"
        yum install -y php php-fpm php-mysql
            sleep 3
    echo -e "################################################################################\n"
}

function install_mariadb {
    echo -e "################################################################################"
    echo -e "[INFO: ${date}] Installing mariadb and mariadb-server"
        yum install -y mariadb mariadb-server
            sleep 3
    echo -e "[INFO: ${date}] Staring mariadb"
        systemctl start mariadb
            sleep 3
    echo -e "[INFO: ${date}] Enabling mariadb to start on boot"
        systemctl enable mariadb
            sleep 3
        echo -e "[INFO: ${date}] Checking mysql process if running....."
            if pgrep mysqld > /dev/null 2>&1; then
                echo "[INFO: ${date}] mysqld is running....."
            else
                echo "[INFO: ${date}] mysqld is stopped....."
                echo "[INFO: ${date}] starting mysqld service"
                    systemctl start mariadb
                    sleep 3
                echo "[INFO: ${date}] mysqld is started....."
            fi
    echo -e "[INFO: ${date}] Configuring mariadb log"
        sed -i "/^\[mysqld\]/a\\log-warnings=2" /etc/my.cnf
        systemctl restart mariadb
        mysql -u root < mysql_config.sql
    echo -e "################################################################################\n"
}

function config_firewalld {
    echo -e "################################################################################"
    echo -e "[INFO: ${date}] Allowing http and https service on firewalld"
        firewall-cmd --zone=public --permanent --add-service=http
            sleep 3
        firewall-cmd --zone=public --permanent --add-service=https
            sleep 3
    echo -e "[INFO: ${date}] Allowing mariadb port on firewalld"
        firewall-cmd --zone=public --permanent --add-port=3306/tcp
            sleep 3
    echo -e "[INFO: ${date}] Reloading firewalld"
        firewall-cmd --reload
            sleep 3
    echo -e "################################################################################\n"
}

function install_fail2ban {
    echo -e "################################################################################"
    echo -e "[INFO: ${date}] Installing fail2ban fail2ban-firewalld fail2ban-systemd"
        yum install -y fail2ban fail2ban-firewalld fail2ban-systemd
            sleep 3
    echo -e "[INFO: ${date}] Staring fail2ban"
        systemctl start fail2ban
            sleep 3
    echo -e "[INFO: ${date}] Enabling fail2ban to start on boot"
        systemctl enable fail2ban
            sleep 3
    echo -e "################################################################################\n"
}

function configure_fail2ban {
    echo -e "################################################################################"
    echo -e "[INFO: ${date}] Creating http-get-dos conf file"
    echo -e '# Fail2Ban configuration file 
[Definition]

# Option: failregex 
# Note: This regex will match any GET entry in your logs, so basically all valid and not valid entries are a match. 
# You should set up in the jail.conf file, the maxretry and findtime carefully in order to avoid false positives. 
failregex = ^<HOST> -.*"(GET|POST).* 
# Option: ignoreregex 
ignoreregex =' > /etc/fail2ban/filter.d/http-get-dos.conf
        cat  /etc/fail2ban/filter.d/http-get-dos.conf
    echo -e "[INFO: ${date}] Copying config file"
        cp jail.conf /etc/fail2ban/jail.local
    echo -e "[INFO: ${date}] Restarting fail2ban"
        systemctl restart fail2ban
            sleep 3
    echo -e "[INFO: ${date}] Checking fail2ban status"
        systemctl status fail2ban -l
            sleep 3
    echo -e "[INFO: ${date}] Checking fail2ban-client status"
        fail2ban-client status
            sleep 3
    echo -e "################################################################################\n"
}

function setup_sample_website {
    echo -e "################################################################################"
    echo -e "[INFO: ${date}] Cloning template on github"
        git clone https://github.com/alexis-luna/bootstrap-simple-admin-template.git
    echo -e "[INFO: ${date}] Done Cloning template"
    echo -e "[INFO: ${date}] Copying static files to /var/www/html"
        cp -r bootstrap-simple-admin-template/* /var/www/html/
    echo -e "[INFO: ${date}] Done Copying static files to /var/www/html"
    echo -e "################################################################################\n"

}

#### Main Function
function __main {
    install_additionals
    install_httpd
    install_php
    install_mariadb
    install_fail2ban
    config_firewalld
    configure_fail2ban
    setup_sample_website
}

echo -e "################################################################################"
echo -e "[INFO: ${date}] Running the installation and configuration"
    __main
echo -e "[INFO: ${date}] Finished the installation and configuration"
echo -e "################################################################################\n"

