import imageio

n_frame = 337
frames = []
for i in range(n_frame):
    try:
        frames.append(imageio.imread('./10052_graph/{}.png'.format(i)))
    except:
        print('ignore {}.png'.format(i))
imageio.mimsave('graph_10052.gif',frames,'GIF',duration=0.1)
