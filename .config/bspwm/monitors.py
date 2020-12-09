import math
import subprocess

def divide_chunks(l, n):
    for i in range(0, len(l), n):
        yield l[i:i + n]

def run(args):
    print("Running: " + args)
    return subprocess.run(args, shell=True, capture_output=True).stdout.decode("ascii")

desktops = [1,2,3,4,5,6,7,8,9,0]
# desktops = ['I', 'II', 'III', "IV", "V", "VI", "VII", "VIII", "IX", "X"]

monitors = run("bspc query -M --names").split()
print("Connected monitors are: " + " ".join(monitors))

#Reorders the list so that the primary monitor gets the first chunk of the desktops
if len(monitors) > 1:
    primary_display = run('xrandr --query | grep " primary" | cut -d" " -f1').rstrip()
    print("Primary display is: " + primary_display)
    try:
        monitors.remove(primary_display)
        monitors.insert(0, primary_display)
    except:
        print(f"Failed to remove primary display: {primary_display}")

    #remove disconnected display from bspwm
    disconncted_monitors = run('xrandr --query | grep " disconnected" | cut -d" " -f1').split()
    for monitor in monitors:
        for disconnected in disconncted_monitors:
            if monitor == disconnected:
                run(f"bspc monitor {monitor} --remove")

print("Monitor order is: " + " ".join(monitors))

#Useful when we change our monitor setup.
#I.e When we disconnect a monitor we need to take all of the windows from that monitor's workspaces to our currently connected monitors
run("bspc wm --adopt-orphans")

chunk_size = math.floor(len(desktops) / len(monitors))
print("Each monitor gets " + str(chunk_size) + " amount of desktops")

monitor_desktop_chunks = list(divide_chunks(desktops, chunk_size))
print("There are " + str(len(monitor_desktop_chunks)) + " monitor desktops chunks")

#if we dont get an evenly sized chunks, take the leftover and add it to the last monitor
if (len(desktops) % len(monitors)) != 0:
    last_index = len(monitor_desktop_chunks)-1
    overflow = monitor_desktop_chunks[len(monitor_desktop_chunks)-1]
    last_index = len(monitor_desktop_chunks)-2
    print("There chunks are not evenly sized. Addding " + str(overflow) + " desktops to the last monitor")
    monitor_desktop_chunks[last_index] = monitor_desktop_chunks[last_index] + overflow

chunk_used_counter = 0
for monitor_name in monitors:
    monitor_assigned_chunk = ' '.join(str(e) for e in monitor_desktop_chunks[chunk_used_counter])
    run(f"bspc monitor {monitor_name} -d {monitor_assigned_chunk}")
    chunk_used_counter = chunk_used_counter + 1
