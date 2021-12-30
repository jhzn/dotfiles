import math
from typing import List, Dict
import models


def divide_chunks(list: list[int], count: int):
    for i in range(0, len(list), count):
        yield list[i:i + count]


def get_monitor_names(sway_outputs: List[models.Swayoutput]) -> List[str]:
    monitor_names = []
    for monitor in sway_outputs:
        monitor_names.append(monitor.name)
    return monitor_names


def list_monitors(sway_outputs: List[models.Swayoutput]):
    print("Use the number of your desired primary monitor as argument to the --generate command\n")
    counter = 1
    for monitor in sway_outputs:
        print("{}: {} ({})".format(counter, monitor.name, monitor.model))
        counter += 1


def get_workspaces_divided_per_monitor(monitor_count: int) -> List[List[int]]:
    workspaces = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    chunk_size = math.floor(len(workspaces) / monitor_count)

    # Check if our workspaces are evenly distributable on our monitors
    if len(workspaces) % monitor_count == 0:
        return list(divide_chunks(workspaces, chunk_size))
    else:
        monitor_desktop_chunks: List[List[int]] = []
        remains = len(workspaces) % monitor_count
        is_first_monitor_handled = False
        next = 0
        #  print("chunk_size", chunk_size)
        for i in range(0, monitor_count):
            #  print(i)
            if not is_first_monitor_handled:
                next = chunk_size + remains
                monitor_desktop_chunks.insert(i, workspaces[i:next])
                is_first_monitor_handled = True
            else:
                monitor_desktop_chunks.insert(
                    i, workspaces[next:next + chunk_size])
                next = next + chunk_size

        return monitor_desktop_chunks


def monitor_assignments(monitor_variables_map: models.MonitorMap, primary_monitor: str) -> List[str]:
    out = []
    for monitor_name, monitor in monitor_variables_map.items():
        if monitor_name is primary_monitor:
            out.append("{}={} #This is your 'primary' monitor".format(
                monitor.variable_name.replace("$", ""), monitor_name))
        else:
            out.append("{}={}".format(monitor.variable_name.replace("$", ""), monitor_name))

    return out


def conf_outputs(sway_outputs, monitor_variables_map: models.MonitorMap) -> List[str]:
    out = []
    for monitor in sway_outputs:
        if not monitor.active:
            out.append("swaymsg output {} disable".format(monitor.name))
        else:
            mon = monitor_variables_map[monitor.name]

            command = [
                "swaymsg output {}".format(
                    mon.variable_name),
                "res {}x{}@{}hz".format(
                    monitor.current_mode.width,
                    monitor.current_mode.height,
                    monitor.current_mode.refresh,
                ),
                "scale {}".format(monitor.scale),
                "transform {}".format(monitor.transform),
                "pos {} {}".format(monitor.rect.x, monitor.rect.y),
                "enable"
            ]
            out.append(" ".join(command))

    return out


def arrange_workspacess(monitor_map: models.MonitorMap) -> List[str]:
    out = []
    for monitor_name, monitor in monitor_map.items():
        for workspace in monitor.assigned_workspaces:
            out.append(
                f"swaymsg \"workspace {workspace} output {monitor.variable_name}; workspace number {workspace}; move workspace to {monitor.variable_name}\"")
    # focuses workspace 1 after script has run
    out.append('swaymsg "workspace number 1"')
    return out


def waybar(monitor_map: models.MonitorMap) -> List[str]:
    out = []
    for monitor_name, monitor in monitor_map.items():
        for workspace in monitor.assigned_workspaces:
            out.append('"{}": ["{}"],'.format(workspace, monitor.variable_name))
    return out


def create_monitor_map(sway_outputs, primary_monitor: str) -> models.MonitorMap:
    monitor_names = get_monitor_names(sway_outputs)

    monitor_map: Dict[str, models.Monitor] = {}
    for m in sway_outputs:
        if not m.active:
            monitor_names.remove(m.name)

    monitor_desktop_chunks = get_workspaces_divided_per_monitor(len(monitor_names))
    current_chunk_counter = 0

    # Very crude assignement because primary_monitor needs to have $MON_0
    # Rearrange monitors in list so that our primary monitor gets the first chunk of the workspaces
    # TODO make prettier
    for monitor in sway_outputs:
        monitor_name = monitor.name
        if not monitor.active:
            continue
        if monitor_name is primary_monitor:
            monitor_assigned_chunk = monitor_desktop_chunks[current_chunk_counter]
            monitor_map[monitor_name] = models.Monitor(
                variable_name="$MON_{}".format(current_chunk_counter),
                assigned_workspaces=monitor_assigned_chunk,
            )
            current_chunk_counter = current_chunk_counter + 1

    for monitor in sway_outputs:
        monitor_name = monitor.name
        if not monitor.active:
            continue

        if monitor_name is not primary_monitor:
            monitor_assigned_chunk = monitor_desktop_chunks[current_chunk_counter]
            monitor_map[monitor_name] = models.Monitor(
                variable_name="$MON_{}".format(current_chunk_counter),
                assigned_workspaces=monitor_assigned_chunk,
            )
            current_chunk_counter = current_chunk_counter + 1

    return monitor_map


def parse_sway_output(sway_outputs) -> List[models.Swayoutput]:
    out = []
    for monitor in sway_outputs:
        out.append(models.Swayoutput(
            name=monitor["name"],
            model=monitor["model"],
            active=monitor["active"],
            current_mode=models.Current_mode(
                width=monitor["current_mode"]["width"],
                height=monitor["current_mode"]["height"],
                refresh=monitor["current_mode"]["refresh"] / 1000,
            ),
            scale=monitor["scale"],
            transform=monitor["transform"],
            rect=models.Rect(
                x=monitor["rect"]["x"],
                y=monitor["rect"]["y"],
            )

        ))
    return out


def generate(sway_outputs: models.Swayoutput, primary_monitor_number: int):
    monitor_names = get_monitor_names(sway_outputs)
    primary_monitor = monitor_names[primary_monitor_number - 1]
    monitor_map = create_monitor_map(sway_outputs, primary_monitor)

    print("#!/bin/bash\n")
    print("\n".join(monitor_assignments(monitor_map, primary_monitor)))
    print("")
    print("\n".join(arrange_workspacess(monitor_map)))
    print("")
    print("\n".join(conf_outputs(sway_outputs, monitor_map)))
    print("")

    # generate persistent workspaces for waybar so that the assigned workspaces are shown in the bar of the individual monitors
    print("""waybar_persistent_workspaces=$(cat << EOF
{{
{}
}}
EOF
)
""".format("\n".join(waybar(monitor_map))))

    print("""jq '."sway\/workspaces".persistent_workspaces = '"$waybar_persistent_workspaces" \\
    ~/.config/waybar/config_base > ~/.config/waybar/config""")
