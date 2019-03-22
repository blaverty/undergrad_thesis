#!/usr/local/bin/python3

import sys
import os.path


for line in open(sys.argv[1]):
    line = line.split()
    name = str(line[0])
    start = int(line[1]) 
    end = int(line[2]) + 1
    snp = str(line[3])


    with open('/home/brianne/sepsis2/Card/geneFamily/nucOrder/all/alignmafft/sequences/'+name) as consensus:
        line = consensus.readline()
        seq = line[start:end] 
        GC = int((seq.count("G")+seq.count("C")+seq.count("c")+seq.count("g"))/len(seq)*100)
        end = end -1
        if "-" in seq:
            continue
        else:
            print(">"+ name + "|" + str(start) + "-" + str(end) + "|" + snp + "|" + str(GC))
            print(seq)
 

