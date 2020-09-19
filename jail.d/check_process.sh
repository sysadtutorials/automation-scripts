#!/bin/bash
#

date=`date +%m-%d-%Y-%T`
processLogFile="/var/log/check_process.log"


### This function will check the mysql/mariadb process and if it found out that the process is stopped it will rerun it
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

### This function will check the httpd process and if it found out that the process is stopped it will rerun it
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

### This is the main function that will run the checking process
function check_process {
    check_mysql
    check_httpd
}

### This will run the main function and output it to the logfile
while true; do
    check_process >> ${processLogFile}
        sleep 5
done
