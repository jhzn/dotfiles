
# This script outputs the current display layout to a script which for example,
# enables the user to quickly switch between layouts using scripts
# You can for example use the "wdisplays" program to configure your layout and then use this script to save the layout to a script

import subprocess

def run(args):
    #print("Running: " + args)
    return subprocess.run(args, shell=True, capture_output=True).stdout.decode("ascii")

outputs = run("swaymsg --raw -t get_outputs")

import json
parsed = json.loads(outputs)
monitor_commands = []
for monitor in parsed:

    if monitor["active"] == False:
        monitor_commands.insert(0, "sway output {} disable".format(monitor["name"]))
    else:
        command = [
            "sway output {}".format(monitor["name"]),
            "res {}x{}".format(monitor["current_mode"]["width"], monitor["current_mode"]["height"]),
            "scale {}".format(monitor["scale"]),
            "pos {} {}".format(monitor["rect"]["x"], monitor["rect"]["y"]),
            "enable"
        ]
        monitor_commands.insert(0, " ".join(command))


print("#!/bin/sh\n")
for command in monitor_commands:
    print(command)


