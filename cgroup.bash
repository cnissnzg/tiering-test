for((J=1;J<=101;J+=2));do
    D=$((J*800))
    cgcreate -g memory:pmbench.${J}
    cgexec -g memory:pmbench.${J} /usr/bin/numactl  --cpunodebind=0 -- /usr/local/bin/pmbench -s5120 -m5120 -j1 -c -i -r80 -d ${D} 1800 > result/cgroup_test/pmbench.${J}.log &
    ./cgroup_result_fetch.sh ${J} &
done