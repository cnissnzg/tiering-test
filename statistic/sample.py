import json
import matplotlib.pyplot as plt
import numpy as np

with open('10052.json', 'r', encoding='utf-8') as f:
    events = json.loads("".join(f.readlines()))

phase_n = 8
x = []
y = []
z = []

for i in range(len(events)-10):
    x.append(3*i)
    if events[i]['top_total']['hit'] < 200 and i > 0:
        events[i]['top_total']['avg_msec'] = events[i-1]['top_total']['avg_msec']
    y.append(events[i]['top_total']['avg_msec'])
    cal = events[i]['total']['avg_msec'] * events[i]['total']['hit'] - events[i]['top_total']['avg_msec'] * events[i]['top_total']['hit']
    cal = cal / (events[i]['total']['hit'] - events[i]['top_total']['hit'])
    z.append(cal)

xpoints = np.array(x)
ypoints = np.array(y)
zpoints = np.array(z)
fig = plt.figure()
plt.subplot(2, 1, 1)
plt.plot(xpoints, ypoints)
plt.title("DRAM")
plt.xlabel("sample time(s)")
plt.ylabel("hint time(ms)")

plt.subplot(2, 1, 2)
plt.plot(xpoints, zpoints)
plt.title("PMEM")
plt.xlabel("sample time(s)")
plt.ylabel("hint time(ms)")

plt.suptitle("NUMA statistic (pid 10052)")
plt.tight_layout()
fig.savefig('sample_10052.png')