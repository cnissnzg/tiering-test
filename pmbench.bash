/lkp/benchmarks/vm-scalability/usemem $1g --sleep 200000 &
echo "eatmem $1 started, wait for comsuming mem"
sleep 60s
echo "pmbench start"
cd result
mkdir pmbench_$1
cd pmbench_$1
sudo lkp run ../../pmbench/60G-4G-64-tiering.yaml > output.txt
sudo kill -9 $!