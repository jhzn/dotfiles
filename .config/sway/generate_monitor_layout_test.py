import subprocess
from argparse import ArgumentParser
import json
import math
from typing import List, Dict

def divide_chunks(list: list[int], count: int):
    for i in range(0, len(list), count):
        yield list[i:i + count]

def get_workspaces_divided_per_monitor(monitor_names: List[str]) -> List[List[int]]:
    workspaces = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    chunk_size = math.floor(len(workspaces) / len(monitor_names))

    # Check if our workspaces are evenly distributable on our monitors
    if len(workspaces) % len(monitor_names) == 0:
        return list(divide_chunks(workspaces, chunk_size))
    else:
        monitor_desktop_chunks: List[List[int]] = []
        remains = len(workspaces) % len(monitor_names)
        is_first_monitor_handled = False
        next = 0
        #  print("chunk_size", chunk_size)
        for i in range(0, len(monitor_names)):
            #  print(i)
            if not is_first_monitor_handled:
                next = chunk_size + remains
                monitor_desktop_chunks.insert(i, workspaces[i:next])
                is_first_monitor_handled = True
            else:
                monitor_desktop_chunks.insert(i, workspaces[next:next + chunk_size])
                next = next + chunk_size

        return monitor_desktop_chunks

out = get_workspaces_divided_per_monitor(["A", "B", "C", "D"])
print(out)



