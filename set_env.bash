echo offline > /sys/devices/system/memory/auto_online_blocks
daxctl reconfigure-device -m system-ram dax0.2
echo 1 > /sys/kernel/mm/numa/demotion_enabled
echo 2 > /proc/sys/kernel/numa_balancing
echo 100 > /proc/sys/kernel/numa_balancing_rate_limit_mbps
echo 1 > /proc/sys/kernel/numa_balancing_wake_up_kswapd_early
echo 1 > /proc/sys/kernel/numa_balancing_scan_demoted
echo 16 > /proc/sys/kernel/numa_balancing_demoted_threshold
echo 1 > /proc/sys/kernel/numa_statistic_enable
swapoff -a