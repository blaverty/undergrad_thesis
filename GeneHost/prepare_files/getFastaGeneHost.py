#!/usr/local/bin/python3

import sys
import glob
import os

for line in open(sys.argv[1]):
    line = line.split()
    name = line[0]
    s = int(line[1])
    e = int(line[2])

    path = "/home/brianne/sepsis2/AMR4/sequence.fasta/"+name+"*"
    files = glob.glob(path)
    if len(files) != 0:
        for filename in files:
            with open(filename, 'r') as f:
                header = f.readline().rstrip()
                next(f)
                genome = f.read().replace('\n','')
                seq = genome[s:e]
                print(header)
                print(seq)
    else:
        with(open("download","a")) as outfile: 
            outfile.write(name+'\n')
