numactl -m 1 /lkp/benchmarks/vm-scalability/usemem $1g --sleep 200000 &
echo "eatmem $1 started, wait for comsuming mem"
sleep 60s
echo "pmbench start"
cd result
mkdir -p pmbench_$1_$2
cd pmbench_$1_$2
sudo lkp run ../../pmbench/60G-8G-32-tiering.yaml > output.txt
sudo kill -9 $!