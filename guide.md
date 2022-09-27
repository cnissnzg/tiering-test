sudo make -j8
sudo make INSTALL_MOD_STRIP=1 modules_install
sudo make install

su
echo offline > /sys/devices/system/memory/auto_online_blocks
daxctl reconfigure-device -m system-ram dax0.2
echo 1 > /sys/kernel/mm/numa/demotion_enabled
echo 2 > /proc/sys/kernel/numa_balancing
echo 30 > /proc/sys/kernel/numa_balancing_rate_limit_mbps
echo 1 > /proc/sys/kernel/numa_balancing_wake_up_kswapd_early
echo 1 > /proc/sys/kernel/numa_balancing_scan_demoted
echo 16 > /proc/sys/kernel/numa_balancing_demoted_threshold

cd test/
cd pmbench
./usemem.sh 
sudo lkp run ./60G-4G-64-tiering.yaml