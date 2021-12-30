from generate_lib import *

def test_get_workspaces_divided_per_monitor():
    got = get_workspaces_divided_per_monitor(["A", "B", "C", "D"])
    assert got == [[1, 2, 3, 4], [5, 6], [7, 8], [9, 10]], "failed expected: {}".format(got)

if __name__ == "__main__":
    test_get_workspaces_divided_per_monitor()
    print("Everything passed")
