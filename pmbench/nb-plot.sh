#!/bin/sh

[ $# -lt 1 ] && {
	echo "Usage: $0 <name> [<ext>]"
	exit 1
}

lkpdir=/home/yifeng/git/lkp-tests/tools
datadir=/lkp/result/pmbench/1-1-even-performance-yhnb69-2000-60G-1-even-64-1-normal_ih-80-1800s-0-100-7-4096M-never-never/ddst-PowerEdge-R750/ubuntu/defconfig/gcc-11/5.15.0tiering0.8/0
oname=$1
odir=~/report/tmp/$oname
rm -rf "$odir"
mkdir -p $odir
cd $datadir
ruby $lkpdir/matrix2csv matrix.json* $odir/matrix.csv
#cp cat-proc-pid $odir
#cp ftrace.data.xz $odir
#cp kmsg.xz $odir

opts="-r --y-min 0"
opts2="-r"

ext=png
[ $# -eq 2 ] && ext=$2

#[ -f bpfcc-tools ] && ~/report/tools/plot-bpf "$oname"

ruby $lkpdir/plot-tool $opts -o $odir/numa-meminfo-s01-active-in.$ext -x numa-meminfo.time matrix.json* numa-meminfo.node0.Active matrix.json* numa-meminfo.node0.Inactive matrix.json* numa-meminfo.node1.Active matrix.json* numa-meminfo.node1.Inactive
ruby $lkpdir/plot-tool $opts -o $odir/numa-meminfo-anon.$ext -x numa-meminfo.time matrix.json* numa-meminfo.node0.AnonPages matrix.json* numa-meminfo.node1.AnonPages matrix.json* numa-meminfo.node2.AnonPages matrix.json* numa-meminfo.node3.AnonPages
ruby $lkpdir/plot-tool $opts -o $odir/numa-meminfo-file.$ext -x numa-meminfo.time matrix.json* numa-meminfo.node0.FilePages matrix.json* numa-meminfo.node1.FilePages matrix.json* numa-meminfo.node2.FilePages matrix.json* numa-meminfo.node3.FilePages
ruby $lkpdir/plot-tool $opts -o $odir/numa-meminfo-inactive-file.$ext -x numa-meminfo.time matrix.json* "numa-meminfo.node0.Inactive(file)" matrix.json* "numa-meminfo.node1.Inactive(file)" matrix.json* "numa-meminfo.node2.Inactive(file)"  matrix.json* "numa-meminfo.node3.Inactive(file)"
ruby $lkpdir/plot-tool $opts -o $odir/numa-meminfo-used.$ext -x numa-meminfo.time matrix.json* numa-meminfo.node0.MemUsed matrix.json* numa-meminfo.node1.MemUsed matrix.json* numa-meminfo.node2.MemUsed matrix.json* numa-meminfo.node3.MemUsed
#ruby $lkpdir/plot-tool $opts -o $odir/numa-pmem.$ext -x perf-stat.time matrix.json* perf-stat.i.S0.UNC_M_PMM_RPQ_throughput_MBps matrix.json* perf-stat.i.S1.UNC_M_PMM_RPQ_throughput_MBps
ruby $lkpdir/plot-tool $opts2 -o $odir/node-free.$ext --x-range 200,600 -x numa-vmstat.time matrix.json* numa-vmstat.node1.nr_free_pages matrix.json* numa-vmstat.node0.nr_free_pages

#ruby $lkpdir/plot-tool $opts -o $odir/pgsteal_kswapd.$ext --x-range 200,300 -x proc-vmstat.time matrix.json* proc-vmstat.pgsteal_kswapd
ruby $lkpdir/plot-tool $opts -o $odir/pgsteal_kswapd.$ext -x proc-vmstat.time matrix.json* proc-vmstat.pgsteal_kswapd
ruby $lkpdir/plot-tool $opts -o $odir/dpgsteal_kswapd.$ext -d -x proc-vmstat.time matrix.json* proc-vmstat.pgsteal_kswapd
ruby $lkpdir/plot-tool $opts -o $odir/pageoutrun.$ext -x proc-vmstat.time matrix.json* proc-vmstat.pageoutrun
ruby $lkpdir/plot-tool $opts -o $odir/d30pgdemote_kswapd.$ext -d --diff-distance 30 -x proc-vmstat.time matrix.json* proc-vmstat.pgdemote_kswapd matrix.json* proc-vmstat.pgpromote_demoted
ruby $lkpdir/plot-tool $opts -o $odir/d60pgsteal_kswapd.$ext -d --diff-distance 60 -x proc-vmstat.time matrix.json* proc-vmstat.pgsteal_kswapd matrix.json* proc-vmstat.pgpromote_demoted
ruby $lkpdir/plot-tool $opts -o $odir/pgpromote_demoted.$ext -x proc-vmstat.time matrix.json* proc-vmstat.pgpromote_demoted
ruby $lkpdir/plot-tool $opts -o $odir/d30pgpromote_demoted.$ext -d --diff-distance 30 -x proc-vmstat.time matrix.json* proc-vmstat.pgpromote_demoted
ruby $lkpdir/plot-tool $opts -o $odir/d100pgdemote_file.$ext -d --diff-distance 100 -x proc-vmstat.time matrix.json* proc-vmstat.pgdemote_file
ruby $lkpdir/plot-tool $opts -o $odir/d1000pgdemote_file.$ext -d --diff-distance 1000 -x proc-vmstat.time matrix.json* proc-vmstat.pgdemote_file
ruby $lkpdir/plot-tool $opts -o $odir/pgsteal_direct.$ext -x proc-vmstat.time matrix.json* proc-vmstat.pgsteal_direct
ruby $lkpdir/plot-tool $opts -o $odir/pgscan_kswapd.$ext -x proc-vmstat.time matrix.json* proc-vmstat.pgscan_kswapd
ruby $lkpdir/plot-tool $opts -o $odir/pgscan_direct.$ext -x proc-vmstat.time matrix.json* proc-vmstat.pgscan_direct
ruby $lkpdir/plot-tool $opts -o $odir/pgmigrate_success.$ext -x proc-vmstat.time matrix.json* proc-vmstat.pgmigrate_success
ruby $lkpdir/plot-tool $opts -o $odir/pgmigrate_fail.$ext -x proc-vmstat.time matrix.json* proc-vmstat.pgmigrate_fail
ruby $lkpdir/plot-tool $opts -o $odir/numa_pte_updates.$ext -d -x proc-vmstat.time matrix.json* proc-vmstat.numa_pte_updates
ruby $lkpdir/plot-tool $opts -o $odir/numa_huge_pte_updates.$ext -x proc-vmstat.time matrix.json* proc-vmstat.numa_huge_pte_updates
ruby $lkpdir/plot-tool $opts -o $odir/numa_hint_faults.$ext -d -x proc-vmstat.time matrix.json* proc-vmstat.numa_hint_faults matrix.json* proc-vmstat.numa_hint_faults_local
ruby $lkpdir/plot-tool $opts -o $odir/d60numa_pages_migrated.$ext -d --diff-distance 60 -x proc-vmstat.time matrix.json* proc-vmstat.numa_pages_migrated
ruby $lkpdir/plot-tool $opts -o $odir/d60numa_migrate_file.$ext -d --diff-distance 60 -x proc-vmstat.time matrix.json* proc-vmstat.numa_migrate_file
ruby $lkpdir/plot-tool $opts -o $odir/d1000numa_migrate_file.$ext -d --diff-distance 1000 -x proc-vmstat.time matrix.json* proc-vmstat.numa_migrate_file
ruby $lkpdir/plot-tool $opts -o $odir/numa_wmark.$ext -x proc-vmstat.time matrix.json* proc-vmstat.numa_wmark
ruby $lkpdir/plot-tool $opts -o $odir/try_migrate.$ext -x proc-vmstat.time matrix.json* proc-vmstat.numa_try_migrate
ruby $lkpdir/plot-tool $opts -o $odir/try_migrated.$ext -d -x proc-vmstat.time matrix.json* proc-vmstat.numa_try_migrate
ruby $lkpdir/plot-tool $opts -o $odir/pass_threshold.$ext -x proc-vmstat.time matrix.json* proc-vmstat.numa_pass_threshold
ruby $lkpdir/plot-tool $opts -o $odir/dpass_threshold.$ext -d -x proc-vmstat.time matrix.json* proc-vmstat.numa_pass_threshold
ruby $lkpdir/plot-tool $opts -o $odir/hmem_reclaim.$ext -x numa-vmstat.time matrix.json* numa-vmstat.node0.hmem_reclaim_demote_src matrix.json* numa-vmstat.node1.hmem_reclaim_demote_src
ruby $lkpdir/plot-tool $opts -o $odir/dhmem_reclaim.$ext -d -x numa-vmstat.time matrix.json* numa-vmstat.node0.hmem_reclaim_demote_src matrix.json* numa-vmstat.node1.hmem_reclaim_demote_src
ruby $lkpdir/plot-tool $opts -o $odir/hmem_promote.$ext -x numa-vmstat.time matrix.json* numa-vmstat.node0.hmem_autonuma_promote_dst matrix.json* numa-vmstat.node1.hmem_autonuma_promote_dst
ruby $lkpdir/plot-tool $opts -o $odir/dhmem_promote.$ext -d -x numa-vmstat.time matrix.json* numa-vmstat.node0.hmem_autonuma_promote_dst matrix.json* numa-vmstat.node1.hmem_autonuma_promote_dst
ruby $lkpdir/plot-tool $opts -o $odir/zone_normal.$ext -x zoneinfo.time matrix.json* zoneinfo.node0.Normal.pages.free matrix.json* zoneinfo.node1.Normal.pages.free --x-range 5,180
ruby $lkpdir/plot-tool $opts -o $odir/kswapd_failures.$ext -x numa-vmstat.time matrix.json* numa-vmstat.node0.kswapd_failures_reset matrix.json* numa-vmstat.node0.kswapd_failures_reach_max matrix.json* numa-vmstat.node1.kswapd_failures_reset matrix.json* numa-vmstat.node1.kswapd_failures_reach_max

ruby $lkpdir/plot-tool $opts -o $odir/madv-diff.$ext -x proc-vmstat.time matrix.json* proc-vmstat.numa_pages_migrated matrix.json* proc-vmstat.hmem_autonuma_promote_dst
ruby $lkpdir/plot-tool $opts -o $odir/madv-diff2.$ext -x proc-vmstat.time matrix.json* proc-vmstat.pgsteal_kswapd matrix.json* proc-vmstat.hmem_reclaim_demote_dst

ruby $lkpdir/plot-tool $opts -o $odir/buddy_normal.$ext -x buddyinfo.time matrix.json* buddyinfo.Node.0.zone.Normal.9 matrix.json* buddyinfo.Node.0.zone.Normal.10 matrix.json* buddyinfo.Node.1.zone.Normal.9 matrix.json* buddyinfo.Node.1.zone.Normal.10 --x-range 50,1800
ruby $lkpdir/plot-tool $opts -o $odir/dst_full_fail.$ext -x proc-vmstat.time matrix.json* proc-vmstat.pgmigrate_fail_dst_node_fail
ruby $lkpdir/plot-tool $opts -o $odir/ddst_full_fail.$ext -d -x proc-vmstat.time matrix.json* proc-vmstat.pgmigrate_fail_dst_node_fail

ruby $lkpdir/plot-tool $opts -o $odir/dpromote_success.$ext -d -x numa-vmstat.time matrix.json* numa-vmstat.node0.pgpromote_success matrix.json* numa-vmstat.node1.pgpromote_success
ruby $lkpdir/plot-tool $opts -o $odir/d10promote_success.$ext -d --diff-distance 10 -x numa-vmstat.time matrix.json* numa-vmstat.node0.pgpromote_success matrix.json* numa-vmstat.node1.pgpromote_success
ruby $lkpdir/plot-tool $opts -o $odir/promote_success.$ext --relative-y -x numa-vmstat.time matrix.json* numa-vmstat.node0.pgpromote_success matrix.json* numa-vmstat.node1.pgpromote_success
ruby $lkpdir/plot-tool $opts -o $odir/promote_threshold.$ext -x numa-vmstat.time --x-range 300 matrix.json* numa-vmstat.node0.promote_threshold matrix.json* numa-vmstat.node1.promote_threshold
ruby $lkpdir/plot-tool $opts -o $odir/promote_ratelimit.$ext -x numa-vmstat.time matrix.json* numa-vmstat.node0.promote_ratelimit matrix.json* numa-vmstat.node1.promote_ratelimit

ruby $lkpdir/plot-tool $opts -o $odir/numa-pgscan-kswapd.$ext -x numa-vmstat.time matrix.json* numa-vmstat.node0.pgscan_kswapd matrix.json* numa-vmstat.node1.pgscan_kswapd
ruby $lkpdir/plot-tool $opts -o $odir/numa-pgscan-direct.$ext -x numa-vmstat.time matrix.json* numa-vmstat.node0.pgscan_direct matrix.json* numa-vmstat.node1.pgscan_direct

ruby $lkpdir/plot-tool $opts -o $odir/numa-pgsteal-kswapd.$ext -x numa-vmstat.time matrix.json* numa-vmstat.node0.pgsteal_kswapd matrix.json* numa-vmstat.node1.pgsteal_kswapd
ruby $lkpdir/plot-tool $opts -o $odir/numa-pgsteal-direct.$ext -x numa-vmstat.time matrix.json* numa-vmstat.node0.pgsteal_direct matrix.json* numa-vmstat.node1.pgsteal_direct

# ruby $lkpdir/plot-tool $opts -o $odir/pmem.$ext -x perf-stat.time matrix.json* perf-stat.i.UNC_M_PMM_RPQ_throughput_MBps matrix.json* perf-stat.i.UNC_M_PMM_WPQ_throughput_MBps
# ruby $lkpdir/plot-tool $opts -o $odir/pmem_latency.$ext -x perf-stat.time matrix.json* perf-stat.i.UNC_M_PMM_RPQ_latency_ns matrix.json* perf-stat.i.UNC_M_PMM_WPQ_latency_ns
# ruby $lkpdir/plot-tool $opts -o $odir/dram.$ext -x perf-stat.time matrix.json* perf-stat.i.UNC_M_RPQ_throughput_MBps matrix.json* perf-stat.i.UNC_M_WPQ_throughput_MBps
ruby $lkpdir/plot-tool $opts --split-stat -o $odir/dram_pmem.$ext -x perf-stat.time matrix.json* --x-range 10 perf-stat.i.UNC_M_RPQ_throughput_MBps,DRAM_Read_Throughput_MB/s matrix.json* perf-stat.i.UNC_M_WPQ_throughput_MBps,DRAM_Write_Throughput_MB/s matrix.json* perf-stat.i.UNC_M_PMM_RPQ_throughput_MBps,PMEM_Read_Throughput_MB/s matrix.json* perf-stat.i.UNC_M_PMM_WPQ_throughput_MBps,PMEM_Write_Throughput_MB/s
# ruby $lkpdir/plot-tool $opts -o $odir/dram_latency.$ext -x perf-stat.time matrix.json* perf-stat.i.UNC_M_RPQ_latency_ns matrix.json* perf-stat.i.UNC_M_WPQ_latency_ns
# ruby $lkpdir/plot-tool $opts -o $odir/meminfo.$ext -x meminfo.time matrix.json* meminfo.Memused
ruby $lkpdir/plot-tool $opts -o $odir/cpi.$ext -x perf-stat.time matrix.json* perf-stat.i.cpi
# ruby $lkpdir/plot-tool $opts -o $odir/cache.$ext -x perf-stat.time matrix.json* perf-stat.i.cache-miss-rate%
# ruby $lkpdir/plot-tool $opts -o $odir/mpki.$ext -x perf-stat.time matrix.json* perf-stat.i.MPKI

# ruby $lkpdir/plot-tool $opts -o $odir/imc-ticks.$ext -x perf-stat.time matrix.json* perf-stat.i.UNC_M_CLOCKTICKS

ruby $lkpdir/plot-tool $opts -o $odir/s0-dram-pmem.$ext -x perf-stat.time matrix.json* perf-stat.i.S0.UNC_M_RPQ_throughput_MBps matrix.json* perf-stat.i.S0.UNC_M_WPQ_throughput_MBps matrix.json* perf-stat.i.S0.UNC_M_PMM_RPQ_throughput_MBps matrix.json* perf-stat.i.S0.UNC_M_PMM_WPQ_throughput_MBps
ruby $lkpdir/plot-tool $opts -o $odir/s1-dram-pmem.$ext -x perf-stat.time matrix.json* perf-stat.i.S1.UNC_M_RPQ_throughput_MBps matrix.json* perf-stat.i.S1.UNC_M_WPQ_throughput_MBps matrix.json* perf-stat.i.S1.UNC_M_PMM_RPQ_throughput_MBps matrix.json* perf-stat.i.S1.UNC_M_PMM_WPQ_throughput_MBps
ruby $lkpdir/plot-tool $opts -o $odir/s1-pmem.$ext -x perf-stat.time matrix.json* perf-stat.i.S1.UNC_M_PMM_RPQ_throughput_MBps matrix.json* perf-stat.i.S1.UNC_M_PMM_WPQ_throughput_MBps
ruby $lkpdir/plot-tool $opts -o $odir/s1-pmem_latency.$ext -x perf-stat.time matrix.json* perf-stat.i.S1.UNC_M_PMM_RPQ_latency_ns matrix.json* perf-stat.i.S1.UNC_M_PMM_WPQ_latency_ns
ruby $lkpdir/plot-tool $opts -o $odir/s01-dram.$ext -x perf-stat.time matrix.json* perf-stat.i.S0.UNC_M_RPQ_throughput_MBps matrix.json* perf-stat.i.S0.UNC_M_WPQ_throughput_MBps matrix.json* perf-stat.i.S1.UNC_M_RPQ_throughput_MBps matrix.json* perf-stat.i.S1.UNC_M_WPQ_throughput_MBps
ruby $lkpdir/plot-tool $opts -o $odir/s01-pmem.$ext -x perf-stat.time matrix.json* perf-stat.i.S0.UNC_M_PMM_RPQ_throughput_MBps matrix.json* perf-stat.i.S0.UNC_M_PMM_WPQ_throughput_MBps matrix.json* perf-stat.i.S1.UNC_M_PMM_RPQ_throughput_MBps matrix.json* perf-stat.i.S1.UNC_M_PMM_WPQ_throughput_MBps
ruby $lkpdir/plot-tool $opts -o $odir/s1-dram.$ext -x perf-stat.time matrix.json* perf-stat.i.S1.UNC_M_RPQ_throughput_MBps matrix.json* perf-stat.i.S1.UNC_M_WPQ_throughput_MBps
ruby $lkpdir/plot-tool $opts -o $odir/s1-dram_latency.$ext -x perf-stat.time matrix.json* perf-stat.i.S1.UNC_M_RPQ_latency_ns matrix.json* perf-stat.i.S1.UNC_M_WPQ_latency_ns
# ruby $lkpdir/plot-tool $opts -o $odir/s1-dram_read_latency.$ext -x perf-stat.time matrix.json* perf-stat.i.S1.UNC_M_RPQ_latency_ns
# ruby $lkpdir/plot-tool $opts -o $odir/s1-meminfo.$ext -x numa-meminfo.time matrix.json* numa-meminfo.node1.AnonPages
# ruby $lkpdir/plot-tool $opts -o $odir/s1-cpi.$ext -x perf-stat.time matrix.json* perf-stat.i.S1.cpi
# ruby $lkpdir/plot-tool $opts -o $odir/s1-cache.$ext -x perf-stat.time matrix.json* perf-stat.i.S1.cache-miss-rate%
# ruby $lkpdir/plot-tool $opts -o $odir/s1-tlb.$ext -x perf-stat.time matrix.json* perf-stat.i.S1.dTLB-load-miss-rate% matrix.json* perf-stat.i.S1.dTLB-store-miss-rate%
# ruby $lkpdir/plot-tool $opts -o $odir/s1-mpki.$ext -x perf-stat.time matrix.json* perf-stat.i.S1.MPKI
# ruby $lkpdir/plot-tool $opts -o $odir/s1-cpm.$ext -x perf-stat.time matrix.json* perf-stat.i.S1.cycles-between-cache-misses
ruby $lkpdir/plot-tool $opts -o $odir/mpstat.$ext -x mpstat.time matrix.json* mpstat.node.1.usr% matrix.json* mpstat.node.1.sys% matrix.json* mpstat.node.1.idle%

ruby $lkpdir/plot-tool $opts -o $odir/cg-numa-stat-a.$ext -x memory--numa_stat.time matrix.json* memory--numa_stat.pmbench.1.total.N1 matrix.json* memory--numa_stat.pmbench.2.total.N0 matrix.json* memory--numa_stat.pmbench.8.total.N0 matrix.json* memory--numa_stat.pmbench.16.total.N0 matrix.json* memory--numa_stat.pmbench.24.total.N0 matrix.json* memory--numa_stat.pmbench.32.total.N0 matrix.json* memory--numa_stat.pmbench.40.total.N0 matrix.json* memory--numa_stat.pmbench.48.total.N0 matrix.json* memory--numa_stat.pmbench.56.total.N0 matrix.json* memory--numa_stat.pmbench.64.total.N0

ruby $lkpdir/plot-tool $opts -o $odir/cg-numa-stat-a1.$ext -x memory--numa_stat.time matrix.json* memory--numa_stat.pmbench.1.total.N1 matrix.json* memory--numa_stat.pmbench.7.total.N1 matrix.json* memory--numa_stat.pmbench.15.total.N1 matrix.json* memory--numa_stat.pmbench.23.total.N1 matrix.json* memory--numa_stat.pmbench.31.total.N1 matrix.json* memory--numa_stat.pmbench.39.total.N1 matrix.json* memory--numa_stat.pmbench.47.total.N1 matrix.json* memory--numa_stat.pmbench.55.total.N1 matrix.json* memory--numa_stat.pmbench.63.total.N1

ruby $lkpdir/plot-tool $opts -o $odir/cg-numa-stat-anon-a.$ext -x memory--numa_stat.time matrix.json* memory--numa_stat.pmbench.1.anon.N1 matrix.json* memory--numa_stat.pmbench.2.anon.N0 matrix.json* memory--numa_stat.pmbench.8.anon.N0 matrix.json* memory--numa_stat.pmbench.16.anon.N0 matrix.json* memory--numa_stat.pmbench.24.anon.N0 matrix.json* memory--numa_stat.pmbench.32.anon.N0 matrix.json* memory--numa_stat.pmbench.40.anon.N0 matrix.json* memory--numa_stat.pmbench.48.anon.N0 matrix.json* memory--numa_stat.pmbench.56.anon.N0 matrix.json* memory--numa_stat.pmbench.64.anon.N0

ruby $lkpdir/plot-tool $opts -o $odir/cg-numa-stat-anon-a1.$ext -x memory--numa_stat.time matrix.json* memory--numa_stat.pmbench.1.anon.N1 matrix.json* memory--numa_stat.pmbench.7.anon.N1 matrix.json* memory--numa_stat.pmbench.15.anon.N1 matrix.json* memory--numa_stat.pmbench.23.anon.N1 matrix.json* memory--numa_stat.pmbench.31.anon.N1 matrix.json* memory--numa_stat.pmbench.39.anon.N1 matrix.json* memory--numa_stat.pmbench.47.anon.N1 matrix.json* memory--numa_stat.pmbench.55.anon.N1 matrix.json* memory--numa_stat.pmbench.63.anon.N1

ruby $lkpdir/plot-tool $opts -o $odir/cg-numa-stat-anon-an.$ext -x memory--numa_stat.time matrix.json* memory--numa_stat.pmbench.2.anon.N1 matrix.json* memory--numa_stat.pmbench.2.anon.N0 matrix.json* memory--numa_stat.pmbench.6.anon.N0 matrix.json* memory--numa_stat.pmbench.6.anon.N1 matrix.json* memory--numa_stat.pmbench.1.anon.N0 matrix.json* memory--numa_stat.pmbench.1.anon.N1 matrix.json* memory--numa_stat.pmbench.15.anon.N0 matrix.json* memory--numa_stat.pmbench.15.anon.N1

ruby $lkpdir/plot-tool $opts -o $odir/s01d01-dram.$ext -x perf-stat.time matrix.json* perf-stat.i.S0-D0.UNC_M_RPQ_throughput_MBps matrix.json* perf-stat.i.S0-D0.UNC_M_WPQ_throughput_MBps matrix.json* perf-stat.i.S1-D0.UNC_M_RPQ_throughput_MBps matrix.json* perf-stat.i.S1-D0.UNC_M_WPQ_throughput_MBps matrix.json* perf-stat.i.S0-D1.UNC_M_RPQ_throughput_MBps matrix.json* perf-stat.i.S0-D1.UNC_M_WPQ_throughput_MBps matrix.json* perf-stat.i.S1-D1.UNC_M_RPQ_throughput_MBps matrix.json* perf-stat.i.S1-D1.UNC_M_WPQ_throughput_MBps

ruby $lkpdir/plot-tool $opts -o $odir/io.$ext -x vmstat.time matrix.json* vmstat.io.bi matrix.json* vmstat.io.bo
ruby $lkpdir/plot-tool $opts -o $odir/io.bi.$ext -x vmstat.time matrix.json* vmstat.io.bi
