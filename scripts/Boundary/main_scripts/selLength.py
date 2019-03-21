#!/usr/local/bin/python3

import sys
from itertools import groupby
import argparse

#lengths for 25 internal
#oligo25: 51
#oligo50: 77
#oligo75: 102
#oligo100: 128


#lengths for 75 internal
#oligo25: 102
#oligo50: 128
#oligo75: 153
#oligo100: 178

#lengths for 75 internal
#oligo125: 204
#oligo150: 229
#oligo175: 255


parser = argparse.ArgumentParser(description="extract oligos that are desired length")
parser.add_argument("-l", "--length",  help="length of oligos (PRINT LENGTH OF SEQ BEFORE RUNNING)", type=int)
parser.add_argument("filename", nargs="+")
args = parser.parse_args()

with open(sys.argv[3]) as infile:
    head = lambda x: x.startswith(">")
    for key, group in groupby(infile, head):
        if key:
            header = (''.join(group))
        else:
            seq = ''.join(group)
            #print(len(seq))
            if len(seq) == args.length:
                print(header.rstrip())
                print(seq.rstrip())
