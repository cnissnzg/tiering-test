#!/usr/bin/python3

from __future__ import print_function
from bcc import BPF
import sys
import os
import time

proc_name = os.environ.get("testcase", "proc_name")
proc_name = os.environ.get("proc_name", proc_name)

buckets = int(os.environ.get("buckets", 64))

vma_size_min = os.environ.get("vma_size_min", "1024UL * 1024 * 1024")

dram_node_max = os.environ.get("dram_node_max", "1")

interval = int(os.environ.get("interval", 30))

program="""
#include <uapi/linux/ptrace.h>
#include <linux/mm_types.h>
#include <linux/mm.h>

#define VMA_SIZE_MIN (%vma_size_min%)
#define DRAM_NODE_MAX (%dram_node_max%)
#define BUCKETS     (%buckets%)

BPF_HISTOGRAM(dram_count, u64, BUCKETS);
BPF_HISTOGRAM(pmem_count, u64, BUCKETS);

int on_page(struct pt_regs *ctx, struct page *page, int pte_dirty,
                struct vm_area_struct *vma,
                int nid,
                unsigned long addr, unsigned long nr_pages)
{
        unsigned long start = vma->vm_start;
        unsigned long end = vma->vm_end;
        unsigned long len = end - start;
        unsigned long offset;

        if (len <= VMA_SIZE_MIN)
                return 0;
        if (vma->vm_file)
                return 0;
        offset = (addr - start) * BUCKETS / len;
        if (offset >= BUCKETS)
                offset = BUCKETS - 1;
        if (nid <= DRAM_NODE_MAX)
                dram_count.increment(offset);
        else
                pmem_count.increment(offset);
        // bpf_trace_printk("on_page, %lx, %lx, %lx!\\n", addr, start, len);
        return 0;
}
"""

program = program.replace("%buckets%", str(buckets))
program = program.replace("%vma_size_min%", vma_size_min)
program = program.replace("%dram_node_max%", dram_node_max)

bpf = BPF(text=program)

bpf.attach_kprobe(event="scan_maps_one_page", fn_name="on_page")
dc = bpf.get_table("dram_count")
pc = bpf.get_table("pmem_count")

def table_to_array(tbl):
    items = sorted(tbl.items(), key=lambda it: it[0].value)
    arr = [0 for i in range(buckets)]
    for k, v in items:
        arr[k.value] = v.value;
    return arr

def print_table(tbl, prefix):
    arr = table_to_array(tbl)
    print("%s: %s" % (prefix, " ".join([str(i) for i in arr])))

while True:
    print("time: %.6f" % time.time())
    dc.clear()
    pc.clear()
    os.system("for p in $(pgrep %s); do cat /proc/$p/scan_maps; done > /dev/null" % \
              proc_name)
    #bpf.trace_print()
    print_table(dc, "dc")
    print_table(pc, "pc")
    time.sleep(interval)
