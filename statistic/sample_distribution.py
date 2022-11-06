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
    p = events[i]['sample_pos'] + phase_n
    y = []
    x = []
    events[i]['detail'][(p-1)%phase_n]['hit'] += events[i]['detail'][p%phase_n]['hit'] 
    total,cur = 0.0,0.0
    for j in range(phase_n-1):
        cur = events[i]['detail'][(p-j-1)%phase_n]['hit'] * 100.0 / events[i]['detail'][(p-j-1)%phase_n]['sample']
        total += cur
        y.append(cur)
        x.append(str((j+1)*5)+'s')
    if total < 0.1:
        continue
    print(y)
    xpoints = np.array(x)
    ypoints = np.array(y)
    fig = plt.figure()
    plt.bar(xpoints,ypoints)
    plt.title("{} sec distribution graph".format((i+1)*5))
    plt.ylim(0,30)
    fig.savefig('./10052_graph/{}.png'.format(i))

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