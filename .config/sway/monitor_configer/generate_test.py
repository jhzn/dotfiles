import json
import difflib
import generate_lib as lib
from models import *


def diff_strings(expected: str, got: str) -> str:
    return "\n".join(difflib.unified_diff(expected.split('\n'), got.split('\n'), fromfile='expected', tofile='got'))


mock_data = [
    Swayoutput(name='HDMI-A-1', model='BenQ GL2240', active=True, current_mode=Current_mode(width=1920, height=1080, refresh=60.0), scale=1.0, transform='normal', rect=Rect(x=0, y=0)),
    Swayoutput(name='DP-1', model='U2777B', active=True, current_mode=Current_mode(width=3840, height=2160, refresh=59.997), scale=1.5, transform='normal', rect=Rect(x=1920, y=0)),
]

mock_swaymsg_data = json.loads("""[
  {
    "id": 3,
    "type": "output",
    "orientation": "none",
    "percent": 0.3214285714285714,
    "urgent": false,
    "marks": [],
    "layout": "output",
    "border": "none",
    "current_border_width": 0,
    "rect": {
      "x": 0,
      "y": 0,
      "width": 1920,
      "height": 1080
    },
    "deco_rect": {
      "x": 0,
      "y": 0,
      "width": 0,
      "height": 0
    },
    "window_rect": {
      "x": 0,
      "y": 0,
      "width": 0,
      "height": 0
    },
    "geometry": {
      "x": 0,
      "y": 0,
      "width": 0,
      "height": 0
    },
    "name": "HDMI-A-1",
    "window": null,
    "nodes": [],
    "floating_nodes": [],
    "focus": [
      101,
      22
    ],
    "fullscreen_mode": 0,
    "sticky": false,
    "active": true,
    "dpms": true,
    "primary": false,
    "make": "BenQ Corporation",
    "model": "BenQ GL2240",
    "serial": "XBA01138SL0",
    "scale": 1.0,
    "scale_filter": "nearest",
    "transform": "normal",
    "adaptive_sync_status": "disabled",
    "current_workspace": "7",
    "modes": [
      {
        "width": 720,
        "height": 400,
        "refresh": 70082
      },
      {
        "width": 640,
        "height": 480,
        "refresh": 59940
      },
      {
        "width": 640,
        "height": 480,
        "refresh": 75000
      },
      {
        "width": 800,
        "height": 600,
        "refresh": 60317
      },
      {
        "width": 800,
        "height": 600,
        "refresh": 75000
      },
      {
        "width": 832,
        "height": 624,
        "refresh": 74551
      },
      {
        "width": 1024,
        "height": 768,
        "refresh": 60004
      },
      {
        "width": 1024,
        "height": 768,
        "refresh": 75029
      },
      {
        "width": 1280,
        "height": 720,
        "refresh": 60000
      },
      {
        "width": 1152,
        "height": 864,
        "refresh": 75000
      },
      {
        "width": 1280,
        "height": 800,
        "refresh": 59910
      },
      {
        "width": 1280,
        "height": 960,
        "refresh": 60000
      },
      {
        "width": 1280,
        "height": 1024,
        "refresh": 60020
      },
      {
        "width": 1280,
        "height": 1024,
        "refresh": 75025
      },
      {
        "width": 1600,
        "height": 900,
        "refresh": 60000
      },
      {
        "width": 1680,
        "height": 1050,
        "refresh": 59883
      },
      {
        "width": 1920,
        "height": 1080,
        "refresh": 60000
      }
    ],
    "current_mode": {
      "width": 1920,
      "height": 1080,
      "refresh": 60000
    },
    "max_render_time": 0,
    "focused": true,
    "subpixel_hinting": "unknown"
  },
  {
    "id": 81,
    "type": "output",
    "orientation": "none",
    "percent": 0.5714285714285714,
    "urgent": false,
    "marks": [],
    "layout": "output",
    "border": "none",
    "current_border_width": 0,
    "rect": {
      "x": 1920,
      "y": 0,
      "width": 2560,
      "height": 1440
    },
    "deco_rect": {
      "x": 0,
      "y": 0,
      "width": 0,
      "height": 0
    },
    "window_rect": {
      "x": 0,
      "y": 0,
      "width": 0,
      "height": 0
    },
    "geometry": {
      "x": 0,
      "y": 0,
      "width": 0,
      "height": 0
    },
    "name": "DP-1",
    "window": null,
    "nodes": [],
    "floating_nodes": [],
    "focus": [
      29,
      16,
      97
    ],
    "fullscreen_mode": 0,
    "sticky": false,
    "active": true,
    "dpms": true,
    "primary": false,
    "make": "Unknown",
    "model": "U2777B",
    "serial": "0x00000EF0",
    "scale": 1.5,
    "scale_filter": "linear",
    "transform": "normal",
    "adaptive_sync_status": "disabled",
    "current_workspace": "2",
    "modes": [
      {
        "width": 720,
        "height": 400,
        "refresh": 70082
      },
      {
        "width": 640,
        "height": 480,
        "refresh": 59940
      },
      {
        "width": 640,
        "height": 480,
        "refresh": 60000
      },
      {
        "width": 640,
        "height": 480,
        "refresh": 66667
      },
      {
        "width": 640,
        "height": 480,
        "refresh": 72809
      },
      {
        "width": 640,
        "height": 480,
        "refresh": 75000
      },
      {
        "width": 720,
        "height": 480,
        "refresh": 59940
      },
      {
        "width": 720,
        "height": 480,
        "refresh": 60000
      },
      {
        "width": 720,
        "height": 576,
        "refresh": 50000
      },
      {
        "width": 800,
        "height": 600,
        "refresh": 60317
      },
      {
        "width": 800,
        "height": 600,
        "refresh": 75000
      },
      {
        "width": 1024,
        "height": 768,
        "refresh": 60004
      },
      {
        "width": 1024,
        "height": 768,
        "refresh": 75029
      },
      {
        "width": 1280,
        "height": 720,
        "refresh": 50000
      },
      {
        "width": 1280,
        "height": 720,
        "refresh": 59940
      },
      {
        "width": 1280,
        "height": 720,
        "refresh": 60000
      },
      {
        "width": 1280,
        "height": 960,
        "refresh": 60000
      },
      {
        "width": 1440,
        "height": 900,
        "refresh": 59887
      },
      {
        "width": 1440,
        "height": 900,
        "refresh": 74984
      },
      {
        "width": 1280,
        "height": 1024,
        "refresh": 60020
      },
      {
        "width": 1280,
        "height": 1024,
        "refresh": 75025
      },
      {
        "width": 1680,
        "height": 1050,
        "refresh": 59954
      },
      {
        "width": 1920,
        "height": 1080,
        "refresh": 50000
      },
      {
        "width": 1920,
        "height": 1080,
        "refresh": 59940
      },
      {
        "width": 1920,
        "height": 1080,
        "refresh": 60000
      },
      {
        "width": 1920,
        "height": 1080,
        "refresh": 60000
      },
      {
        "width": 1920,
        "height": 2160,
        "refresh": 59988
      },
      {
        "width": 3840,
        "height": 2160,
        "refresh": 23976
      },
      {
        "width": 3840,
        "height": 2160,
        "refresh": 24000
      },
      {
        "width": 3840,
        "height": 2160,
        "refresh": 25000
      },
      {
        "width": 3840,
        "height": 2160,
        "refresh": 29981
      },
      {
        "width": 3840,
        "height": 2160,
        "refresh": 29970
      },
      {
        "width": 3840,
        "height": 2160,
        "refresh": 30000
      },
      {
        "width": 3840,
        "height": 2160,
        "refresh": 59997
      }
    ],
    "current_mode": {
      "width": 3840,
      "height": 2160,
      "refresh": 59997
    },
    "max_render_time": 0,
    "focused": false,
    "subpixel_hinting": "unknown"
  }
]""")


def test_get_workspaces_divided_per_monitor():
    got = lib.get_workspaces_divided_per_monitor(2)
    assert got == [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10]], "failed expected: {}".format(got)

    got = lib.get_workspaces_divided_per_monitor(3)
    assert got == [[1, 2, 3, 4], [5, 6, 7], [8, 9, 10]], "failed expected: {}".format(got)

    got = lib.get_workspaces_divided_per_monitor(4)
    assert got == [[1, 2, 3, 4], [5, 6], [7, 8], [9, 10]], "failed expected: {}".format(got)


def test_parse_sway_output():
    got = lib.parse_sway_output(mock_swaymsg_data)
    assert got == mock_data, "failed expected: {}".format(got)


def test_generate():
    got = "\n".join(lib.generate(mock_data, 2))
    expected = """#!/bin/bash

MON_0=DP-1 #This is your 'primary' monitor
MON_1=HDMI-A-1

swaymsg "workspace 1 output $MON_0; workspace number 1; move workspace to $MON_0"
swaymsg "workspace 2 output $MON_0; workspace number 2; move workspace to $MON_0"
swaymsg "workspace 3 output $MON_0; workspace number 3; move workspace to $MON_0"
swaymsg "workspace 4 output $MON_0; workspace number 4; move workspace to $MON_0"
swaymsg "workspace 5 output $MON_0; workspace number 5; move workspace to $MON_0"
swaymsg "workspace 6 output $MON_1; workspace number 6; move workspace to $MON_1"
swaymsg "workspace 7 output $MON_1; workspace number 7; move workspace to $MON_1"
swaymsg "workspace 8 output $MON_1; workspace number 8; move workspace to $MON_1"
swaymsg "workspace 9 output $MON_1; workspace number 9; move workspace to $MON_1"
swaymsg "workspace 10 output $MON_1; workspace number 10; move workspace to $MON_1"
swaymsg "workspace number 1"

swaymsg output $MON_1 res 1920x1080@60.0hz scale 1.0 transform normal pos 0 0 enable
swaymsg output $MON_0 res 3840x2160@59.997hz scale 1.5 transform normal pos 1920 0 enable

prim_waybar_persistent_workspaces=$(cat << EOF
{
"1": ["$MON_0"],
"2": ["$MON_0"],
"3": ["$MON_0"],
"4": ["$MON_0"],
"5": ["$MON_0"],
}
EOF
)

aux_waybar_persistent_workspaces=$(cat << EOF
{
"6": ["$MON_1"],
"7": ["$MON_1"],
"8": ["$MON_1"],
"9": ["$MON_1"],
"10": ["$MON_1"],
}
EOF
)

echo -e '[' > ~/.config/waybar/config
jq '."sway\/workspaces".persistent_workspaces = '"$prim_waybar_persistent_workspaces"' | ."output"= [ "DP-1" ]' ~/.config/waybar/primary_conf_template >> ~/.config/waybar/config
echo -e ',' >> ~/.config/waybar/config
jq '."sway\/workspaces".persistent_workspaces = '"$aux_waybar_persistent_workspaces"' | ."output"= [ "HDMI-A-1" ]' ~/.config/waybar/aux_conf_template >> ~/.config/waybar/config
echo -e ']' >> ~/.config/waybar/config"""

    assert got == expected, "test with 2 monitors failed\n{}".format(diff_strings(expected, got))

    got = "\n".join(lib.generate([mock_data[0]], 1))
    expected = """#!/bin/bash

MON_0=HDMI-A-1 #This is your 'primary' monitor

swaymsg "workspace 1 output $MON_0; workspace number 1; move workspace to $MON_0"
swaymsg "workspace 2 output $MON_0; workspace number 2; move workspace to $MON_0"
swaymsg "workspace 3 output $MON_0; workspace number 3; move workspace to $MON_0"
swaymsg "workspace 4 output $MON_0; workspace number 4; move workspace to $MON_0"
swaymsg "workspace 5 output $MON_0; workspace number 5; move workspace to $MON_0"
swaymsg "workspace 6 output $MON_0; workspace number 6; move workspace to $MON_0"
swaymsg "workspace 7 output $MON_0; workspace number 7; move workspace to $MON_0"
swaymsg "workspace 8 output $MON_0; workspace number 8; move workspace to $MON_0"
swaymsg "workspace 9 output $MON_0; workspace number 9; move workspace to $MON_0"
swaymsg "workspace 10 output $MON_0; workspace number 10; move workspace to $MON_0"
swaymsg "workspace number 1"

swaymsg output $MON_0 res 1920x1080@60.0hz scale 1.0 transform normal pos 0 0 enable

prim_waybar_persistent_workspaces=$(cat << EOF
{
"1": ["$MON_0"],
"2": ["$MON_0"],
"3": ["$MON_0"],
"4": ["$MON_0"],
"5": ["$MON_0"],
"6": ["$MON_0"],
"7": ["$MON_0"],
"8": ["$MON_0"],
"9": ["$MON_0"],
"10": ["$MON_0"],
}
EOF
)

jq '."sway\/workspaces".persistent_workspaces = '"$prim_waybar_persistent_workspaces"' | ."output"= [ "HDMI-A-1" ]' ~/.config/waybar/primary_conf_template > ~/.config/waybar/config"""

    assert got == expected, "test with 1 monitor failed\n{}".format(diff_strings(expected, got))


if __name__ == "__main__":
    test_get_workspaces_divided_per_monitor()
    test_parse_sway_output()
    test_generate()
    print("Everything passed")
