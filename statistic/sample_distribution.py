import json
import matplotlib.pyplot as plt
import numpy as np

with open('171747_9715.json', 'r', encoding='utf-8') as f:
    events = json.loads("".join(f.readlines()))

phase_n = 20
x = []
y = []
z = []

for i in range(len(events)):
    y = []
    z = []
    x = []
    flag = False
    for j in range(phase_n):
        if flag:
            break
        if (events[i]['percent_hit'][j][0] + events[i]['percent_hit'][j][1]) == 0:
            cur = (events[i]['scan_pages'][0] - events[i]['hit_pages'][0]) / ((events[i]['scan_pages'][1] - events[i]['hit_pages'][1]) + (events[i]['scan_pages'][0] - events[i]['hit_pages'][0])) * 100.0
            y.append(cur)
            flag = True
        else:
            cur = events[i]['percent_hit'][j][0]  / (events[i]['percent_hit'][j][0] + events[i]['percent_hit'][j][1]) * 100.0
            y.append(cur)
        z.append(100.0 - cur)
        x.append(str((5*j))+'%')
    xpoints = np.array(x)
    ypoints = np.array(y)
    zpoints = np.array(z)
    fig = plt.figure(figsize=(12, 6))
    plt.bar(xpoints,ypoints,label='DRAM', color = 'royalblue')
    plt.bar(xpoints,zpoints,label='PMEM', color = 'mediumseagreen',bottom=ypoints)
    plt.title("{} sec distribution graph".format((i+1)*5))
    plt.ylim(0,100)
    fig.savefig('./171747_9715_graph/{}.png'.format(i))

'''
xpoints = np.array(x)
ypoints = np.array(y)
zpoints = np.array(z)

plt.subplot(2, 1, 1)
plt.plot(xpoints, ypoints)

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
'''