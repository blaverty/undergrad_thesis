#!/usr/local/bin/python3

import sys
from itertools import groupby

ishead = lambda x: x.startswith(">")

with open(sys.argv[1]) as infile:
    for head, lines in groupby(infile, ishead):
        if head:
            name = ("").join(lines).split(" ")[0][1:]
                
        else:
            seq = ("").join(lines).rstrip()
            seq = seq.replace("\n","")
            seq = seq.upper()
            with open('/home/brianne/sepsis2/AMR4/sequence.fasta2/'+name, "w+") as outfile:
                outfile.write(seq)

