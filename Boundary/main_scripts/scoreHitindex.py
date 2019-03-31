#!/usr/bin/python3

import sys
import re
import glob

for line in open(sys.argv[1]):
    perId = 0
    moreInt = 0 
    if line[0] != "#":
        line = line.split("\t")
        if line[6] == line[7]:
            perId += 1
        else:
            length = line[6]
            match = line[7]
            mis = line[8]
            gap = line[9]
            head = line[0].split("|")
            acc = line[1]
            os = head[2].split("-")[0]
            with open("/home/brianne/sepsis2/AMR4/drive/blastmatch/oligo") as f2:
                p = re.compile(re.escape(line[0]))
                for x in f2:
                    if p.search(x):
                        oligo = next(f2)
                        oligo = oligo[int(line[2])-1:int(line[3])]
            path = "/home/brianne/sepsis2/AMR4/sequence.fasta/%s.*" % acc
            for filename in glob.glob(path):
                with open(filename) as f:
                    fasta = "".join(x.rstrip() for x in f if x[0] != ">")
                    s = int(line[4])-1 
                    e = int(line[5])-1
                    seq = fasta[s:e+1]
            print(seq)
            print("")
            print("oligo:" + oligo)
            print("")

                 


