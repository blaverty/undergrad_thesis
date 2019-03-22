#!/usr/local/bin/python3

import sys
import os.path

d = {"species": 1, "genus":2, "family":3, "order":4, "class":5, "phylum":6, "superkingdom":7, "NONE":8}
d2 = {"1":"species", "2":"genus", "3":"family", "4":"order", "5":"class", "6":"phylum", "7":"superkingdom", "8":"NONE"}

for line in open(sys.argv[1]):
    line = line.split()
    name = str(line[0])
    start = int(line[1]) 
    end = int(line[2]) + 1

    gene = line[3].split(";")
    count = 0
    aro = ""
    snp = ""
    for x in gene:
        ind = x.split("|")
        tax = ind[2]
        if d[tax] > count:
            count = d[tax]
        aro_ind = ind[0]
        snp_ind = ind[1]
        if aro != "":
            aro = aro + ";" + aro_ind
        else:   
            aro = aro_ind
        if snp != "":
            snp = snp + ";" + snp_ind
        else:
            snp = snp_ind
        tax_rank = d2[str(count)] 

    with open('/home/brianne/sepsis2/Card/geneHost/blastn/groups4/alignmafft/sequences/'+name) as consensus:
        line = consensus.readline()
        header = ">%s|%s-%s|snp|aro|GCtax_rank"
        seq = line[start:end] 
        GC = int((seq.count("G")+seq.count("C")+seq.count("c")+seq.count("g"))/len(seq)*100)
        end = end -1
        if "-" in seq:
            continue
        else:
            print(">"+ name + "|" + str(start) + "-" + str(end) + "|" + snp + "|" + aro + "|" + str(GC)+ "|" + tax_rank)
            print(seq)
 

