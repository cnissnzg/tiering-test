#!/bin/bash
sleep 20
i=1
loop=90
while(( $i <= loop ))
do
    echo `cat /sys/fs/cgroup/pmbench.$1/memory.numa_stat` >> result/cgroup_test/pmbench_stat.$1.log
    sleep 20
    i=$((i + 1))
done