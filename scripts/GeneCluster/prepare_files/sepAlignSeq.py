#!/usr/local/bin/python3

import sys
from itertools import groupby

ishead = lambda x: x.startswith(">")

with open(sys.argv[1]) as infile:
    for head, lines in groupby(infile, ishead):
        if head:
            #name = ("").join(lines).split("|")[0][1:]
            name = ("").join(lines).split("|")[4][4:]  
        else:
            seq = ("").join(lines).rstrip()
            seq = seq.replace("\n","")
            seq = seq.upper()
            with open('sequences/'+name, "w+") as outfile:
                outfile.write(seq)

