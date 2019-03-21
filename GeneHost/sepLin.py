#!/usr/local/bin/python3

import sys
from itertools import groupby

ishead = lambda x: x.startswith("FILE")

with open(sys.argv[1]) as infile:
    for head, lines in groupby(infile, ishead):
        if head:
            name = ("").join(lines).split(":")[1][:-6]  
        else:
            seq = ("").join(lines).rstrip()
            with open('lin/'+name, "w+") as outfile:
                outfile.write(seq)

