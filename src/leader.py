import os
import sys
import numpy as np
import pandas as pd

import dispatcher


usage = \
"""
python master.py INPUT

INPUT = path to input file
"""


def read_input(filename):

    with open(filename, 'r') as f:
        params = f.readline()

    params = tuple(map(lambda s: int(s), params.split(" ")))

    rides = pd.read_csv(
        filepath_or_buffer = filename,
        sep = ' ',
        names = ['a', 'b', 'x', 'y', 's', 'f'],
        skiprows=1,
        header = 0,
        dtype =
            {
                "a": np.uint16,
                "b": np.uint16,
                "x": np.uint16,
                "y": np.uint16,
                "s": np.uint32,
                "f": np.uint32})

    return params, rides

def main():

    if len(sys.argv) < 2:
        print(usage)
        sys.exit(1)

    in_filename = sys.argv[1]

    # read input
    params, rides = read_input(in_filename)

    # feed variables to main program
    assignments = dispatcher.go(params, rides)

    pre, _ = os.path.splitext(in_filename)
    out_filename = pre + ".out"

    if not assignments:
        print("Assignments is NULL")
        sys.exit(2)

    # assume assignments is a pandas df
    assignments.to_csv(file_name, sep = " ", encoding='utf-8')


if __name__ == "__main__":
    main()
