#!/usr/local/bin/python3

# matchScoreHit.py blast intlength outlengthofoligo lengthofoligo

import sys
import re


outlen = int(sys.argv[3])
intlen = int(sys.argv[2])
oliglen = int(sys.argv[4])
expOutId = outlen/ oliglen
numId = 0
moreOut = 0
c = 0
allIdout = 0


for line in open(sys.argv[1]):
    imat = 0
    c += 1
    line = line.split("\t")
    qstart = int(line[2])
    qend = int(line[3])

    if qstart == 1 and qend == oliglen and int(line[8]) == int(line[9]):
        numId += 1

    else:
        length = int(line[8])
        qseq = line[6]
        sseq = line[7]

        if "upstream" in line[0]:
            edge = oliglen - intlen - qstart
            if edge < 0:
                outId = 0

            elif length < edge:
                outId = 1
                allIdout += 1

            else:
                for n in range(0,edge):
                    if sseq[n] == qseq[n]:
                        imat += 1
                outId = imat/length
                if outId >= expOutId:
                    allIdout += 1

        else:
            edge = intlen - int(qstart)
            if edge < 0:
                outId = 1
                allIdout += 1
            
            elif length < edge:
                outId = 0 

            else:
                for n in range(edge,len(sseq)):
                    if sseq[n] == qseq[n]:
                        imat += 1                        
                outId = imat/length
                if outId >= expOutId:
                    allIdout += 1
        

        if outId > expOutId:
            moreOut += 1


print(sys.argv[1])
print(allIdout/c, "oligos identified by the outside")
print(numId/c ,"oligos are identical")
print(moreOut/c ,"oligos are id more by outside than we expect")
print(moreOut/(c-numId) ,"oligos are id more by outside than we expect when we exclude identical matches")
print("")


