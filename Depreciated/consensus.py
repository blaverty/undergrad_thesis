#!/usr/local/bin/python3

import sys
from itertools import groupby
import os

ishead = lambda x: x.startswith(">")

tmp = open("tmp"+sys.argv[1], 'w')

with open(sys.argv[1]) as infile:
    for head, lines in groupby(infile, ishead):
        if head:
            continue
                
        else:
            seq = ("").join(lines).rstrip()
            seq = seq.replace("\n","").upper()
            tmp.write(seq+'\n')
tmp.close()


lines = [line.rstrip() for line in open("tmp"+sys.argv[1], 'r')]
length = len(lines[1])

cons = ""
for i in range(length):
    d = {"A":0, "T":0, "C":0, "G":0, "-":0}

    for seq in lines:
        d[seq[i]] += 1
    letter = max(d, key=lambda k: d[k])
    cons = cons + letter

print(cons)  
os.remove("tmp"+sys.argv[1])
 
        
