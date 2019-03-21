#!/usr/local/bin/python3

import sys
from itertools import groupby

with open(sys.argv[1], "r") as infile:
    head = lambda x: x.startswith(">")
    h = 0
    c = 0
    for key, group in groupby(infile, head):
        if key:
            header = ''.join(group)
            c += 1
        else:
            for line in group:
                h += 1
        
    print(sys.argv[1], h/c)
        
