#!/usr/local/bin/python3
import sys
from itertools import groupby
import os.path

#mkcluster.py cluster-tab-delimited-file fastafile

d = {}
ishead = lambda x: x.startswith(">")
with open(sys.argv[2]) as nuc:
    head = None
    for h, lines in groupby(nuc, ishead):
        if h:
            head = list(lines)
            #print(head[0][:-1])
        else:
            seq = ''.join(lines)
            #print(seq)
            d[head[0][:-1]] = seq
    #print(d)



all_seq = set()
for line in open(sys.argv[1]):
    line = line.split("\t")
    clust = line[1]
    name = ">"+line[8]

    if name not in all_seq:
        if os.path.exists('/home/brianne/sepsis2/Card/geneFamily/nucOrder/all/' + clust) == True: 
            a_w = "a"
        else:
            a_w = "w+"

        with open("/home/brianne/sepsis2/Card/geneFamily/nucOrder/all/" + clust, a_w) as outfile:
            outfile.write(name + '\n')
            outfile.write(d[name])

    all_seq.add(name) 



   
