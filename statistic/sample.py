import json
import matplotlib.pyplot as plt
import numpy as np

with open('11849.json', 'r', encoding='utf-8') as f:
    events = json.loads("".join(f.readlines()))

phase_n = 8
x = []
y = []
z = []
yy = []
zz = []

for i in range(len(events)):
    x.append(5*i)
#    if events[i]['top_total']['hit'] < 200 and i > 0:
#        events[i]['top_total']['avg_msec'] = events[i-1]['top_total']['avg_msec']
    z.append((events[i]['scan_pages'][1] - events[i]['scan_pages'][0]) / events[i]['scan_pages'][1] * 100.0)
    y.append(events[i]['scan_pages'][0] / events[i]['scan_pages'][1]* 100.0)
    zz.append((events[i]['hit_pages'][1] - events[i]['hit_pages'][0]) / events[i]['hit_pages'][1] * 100.0)
    yy.append(events[i]['hit_pages'][0] / events[i]['hit_pages'][1]* 100.0)

xpoints = np.array(x)
ypoints = np.array(y)
zpoints = np.array(z)
yypoints = np.array(yy)
zzpoints = np.array(zz)
fig = plt.figure()
plt.subplot(2, 2, 1)
plt.plot(xpoints, ypoints)
plt.title("DRAM")
plt.xlabel("sample time(s)")
plt.ylabel("scan percent(%)")

plt.subplot(2, 2, 2)
plt.plot(xpoints, zpoints)
plt.title("PMEM")
plt.xlabel("sample time(s)")
plt.ylabel("scan percent(%)")

plt.subplot(2, 2, 3)
plt.plot(xpoints, yypoints)
plt.title("DRAM")
plt.xlabel("sample time(s)")
plt.ylabel("hit percent(%)")

plt.subplot(2, 2, 4)
plt.plot(xpoints, zzpoints)
plt.title("PMEM")
plt.xlabel("sample time(s)")
plt.ylabel("hit percent(%)")

plt.suptitle("NUMA statistic (pid 11849)")
plt.tight_layout()
fig.savefig('sample_11849.png')