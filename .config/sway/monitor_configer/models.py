from typing import List, NamedTuple, Dict


class Monitor(NamedTuple):
    # Like [1,2,3]
    assigned_workspaces: List[int]
    # Like $MON_1
    variable_name: str
    is_primary: bool


# Keyed on monitor interface like DP-1
MonitorMap = Dict[str, Monitor]


class Current_mode(NamedTuple):
    width: int
    height: int
    refresh: float


class Rect(NamedTuple):
    x: int
    y: int
    #  width: int
    #  height: int


class Swayoutput(NamedTuple):
    name: str
    model: str
    active: bool
    current_mode: Current_mode
    # Example 2
    scale: float
    # Like normal
    transform: str
    rect: Rect
