#!/bin/bash
#


function check_mysql {
    echo -e "[INFO] Checking mysql process if running....."
        if pgrep mysqld > /dev/null 2>&1; then
            echo "[INFO] mysqld is running....."
        else
            echo "[INFO] mysqld is stopped....."
            echo "[INFO] starting mysqld service"
                systemctl start mariadb
                sleep 3
            echo "[INFO] mysqld is started....."
        fi
}

function check_httpd {
    echo -e "[INFO] Checking httpd process if running....."
        if pgrep httpd > /dev/null 2>&1; then
            echo "[INFO] httpd is running....."
        else
            echo "[INFO] httpd is stopped....."
            echo "[INFO] starting httpd service"
                systemctl start httpd
                sleep 3
            echo "[INFO] httpd is started....."
        fi
}

function check_process {
    check_mysql
    check_httpd
}

check_process
