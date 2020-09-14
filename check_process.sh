#!/bin/bash
#

date=`date +%m-%d-%Y`
processLogFile="/var/log/check_process.log"

function check_mysql {
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
}

function check_httpd {
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
}

function check_process {
    check_mysql
    check_httpd
}

check_process >> ${processLogFile}
