import imageio

n_frame = 277
frames = []
for i in range(n_frame):
    try:
        frames.append(imageio.imread('./11849_graph/{}.png'.format(i)))
    except:
        print('ignore {}.png'.format(i))
imageio.mimsave('graph_11849.gif',frames,'GIF',duration=0.2)
