#!/bin/bash
# This will secure our apache from ddos


echo -e "[INFO] Updating the system"
    yum update -y
    sleep 3
echo -e "\n"

echo -e "[INFO] Installing mod_security and mod_evasive"
    yum install -y mod_security mod_evasive
    sleep 3
echo -e "\n"

echo -e "[INFO] Verifying if mod_evasive.conf are existing"
    if ls /etc/httpd/conf.d/mod_evasive.conf 1 > /dev/null 2&1; then
        echo -e "[INFO] mod_evasive conf do exist"
    else
        echo -e "[INFO] mod_evasive.conf does not exist"
        echo -e "[INFO} Installing mod_evasive"
        yum install -y mod_evasive
    sleep 3
echo -e "\n"

echo -e "[INFO] Verifying if mod_security.conf are existing"
    if ls /etc/httpd/conf.d/mod_security.conf 1 > /dev/null 2&1; then
        echo -e "[INFO] mod_security.conf do exist"
    else
        echo -e "[INFO] mod_security.conf does not exist"
        echo -e "[INFO} Installing mod_security"
        yum install -y mod_security
    sleep 3
echo -e "\n"

