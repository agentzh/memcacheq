#!/bin/sh

export LD_LIBRARY_PATH=/usr/local/BerkeleyDB.4.7/lib:$LDLIBRARY_PATH
killall memcacheq
sleep 2
#rm -rf mydata
#./memcacheq -p 22201 -B 65500 -d -r -c 1024 -m 256 -H ./mydata -A 65536 -N -v > ./testenv.log 2>&1
sleep 1
./memcacheq -p 22201 -B 1024 -d -r -c 1024 -m 64 -H ./mydata -v > ./testenv.log 2>&1
#exec ./memcacheq -p 22201 -B 1020 -d -r -c 1024 -m 256 -A 1024 -H ./mydata -N -v > ./testenv.log 2>&1

