def divide_chunks(l, n):
    for i in range(0, len(l), n):
        yield l[i:i + n]

desktops = [1,2,3,4,5,6,7,8,9,0]
# desktops = ['I', 'II', 'III', "IV", "V", "VI", "VII", "VIII", "IX", "X"]

import subprocess
monitors = subprocess.run(["bspc", "query", "-M", "--names"], capture_output=True).stdout.decode("ascii").split()
print(monitors)
# exit()
#monitors = [ 'DP1', 'eDP1', 'HDM1-1']

#Reorders the list so that the primary monitor gets the first chunk of the desktops
if len(monitors) > 1:
    primary_display = subprocess.run('xrandr --query | grep " primary" | cut -d" " -f1',shell=True, capture_output=True).stdout.decode("ascii").rstrip()
    monitors.remove(primary_display)
    monitors.insert(0, primary_display)

    #remove disconnected display from bspwm
    disconncted_monitors = subprocess.run('xrandr --query | grep " disconnected" | cut -d" " -f1', shell=True, capture_output=True).stdout.decode("ascii").split()
    for monitor in monitors:
        for disconnected in disconncted_monitors:
            if monitor == disconnected:
                args = " ".join(["bspc", "monitor", monitor, "--remove"])
                print(args)
                print(subprocess.run(["sh", "-c", args ]))
                # monitors.remove(disconncted_monitors)

print(monitors)

import math
chunk_size = math.floor(len(desktops) / len(monitors))
print("chunk_size")
print(chunk_size)

monitor_desktop_chunks = list(divide_chunks(desktops, chunk_size))

print("monitor_desktop_chunks")
print(len(monitor_desktop_chunks))

#if we dont get an evenly sized chunks, take the leftover and add it to the last monitor
if (len(desktops) % len(monitors)) != 0:
    last_index = len(monitor_desktop_chunks)-1
    overflow = monitor_desktop_chunks[len(monitor_desktop_chunks)-1]
    last_index = len(monitor_desktop_chunks)-2
    print(overflow)
    monitor_desktop_chunks[last_index] = monitor_desktop_chunks[last_index] + overflow

chunk_used_counter = 0
for monitor_name in monitors:
    monitor_assigned_chunk = ' '.join(str(e) for e in monitor_desktop_chunks[chunk_used_counter])
    args = " ".join(["bspc", "monitor", monitor_name, "-d", monitor_assigned_chunk])
    print(args)
    print(subprocess.run(["sh", "-c", args ]))
    # print(subprocess.run(args,shell=True))

    chunk_used_counter = chunk_used_counter + 1

