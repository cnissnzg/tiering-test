#!/bin/bash
i=1
loop=500
echo -n '['
while(( $i <= loop ))
do
    echo -n `cat /proc/$1/tiering_sample`
    echo -n ,
    sleep 5
done
echo -n ']'