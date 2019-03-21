#!/usr/local/bin/python3
import sys
import os.path
from itertools import groupby

#ishead = lambda x: x.startswith(">")
#
#with open(sys.argv[1]) as infile:
#    keepers = []
#    for head, lines in groupby(infile, ishead):
#        if head:
#            header = (''.join(lines)).rstrip()
#            head = header.split("|")
#                
#        else:
#            check = 0
#            infile= sys.argv[1][:-5]
#            hits = ("").join(lines).rstrip()
#            hits1 = hits.split("\n")
#            for hit in hits1:
#                name = hit.split("\t")[0].split("|")[4]
#                if name not in open('/home/brianne/sepsis2/Card/geneFamily/nucOrder/all/'+infile).read():
#                    check += 1
#            
#            if check == 0:
#                keepers.append(header)
#                keepers.append(hits)
#
#    for x in keepers:
#        print(x)
                
                    
#run listHits first                
            
ishead = lambda x: x.startswith(">")


with open(sys.argv[1]) as infile:
    for head, lines in groupby(infile, ishead):
        if head:
            header = (''.join(lines)).rstrip()
            name = header.split("|")[0][1:]
#                if string is None:
#                    print(sys.argv[1], name)

        else:
            check = 0
            infile= sys.argv[1][:-5]
            line = ("").join(lines).rstrip()
            hits = line.split("\n")

            for hit in hits:
                hit = hit.split()
                qseq = hit[1]
                sseq = hit[2]
                length = int(hit[3])
                nident = int(hit[4])
                if length-nident <= 2:
                    if name not in open('/home/brianne/sepsis2/Card/geneFamily/nucOrder/all/'+infile).read():
                        check += 1
            if check == 0:
                print(header)
                print(line)


                
           
