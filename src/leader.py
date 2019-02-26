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
        names = ['row_s', 'col_s', 'row_f', 'col_f', 't_s', 't_f'],
        skiprows=0,
        header = 0,
        dtype =
            {
                "row_s": np.int32,
                "col_s": np.int32,
                "row_f": np.int32,
                "col_f": np.int32,
                "t_s": np.int32,
                "t_f": np.int32})

    return params, rides

def count_points(assignments,params):
    _, _, _, _, bonus, _ = params



def main():

    if len(sys.argv) < 2:
        print(usage)
        sys.exit(1)

    in_filename = sys.argv[1]
    basename, _ = os.path.splitext(os.path.basename(in_filename))

    # read input
    params, rides = read_input(in_filename)

    # feed variables to main program
    assignments = dispatcher.go(basename, params, rides)

    out_filename = os.path.join("./out", basename + ".out")

    if assignments is None:
        print("Assignments is NULL")
        sys.exit(2)

    # assume assignments is a pandas df
    assignments.to_csv(out_filename, sep = " ", encoding='utf-8')


if __name__ == "__main__":
    main()
