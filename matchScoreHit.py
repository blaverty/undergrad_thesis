#!/usr/local/bin/python3

# matchScoreHit.py blast intlengthofoligo lengthofoligo

import sys
import re


intlen = int(sys.argv[2])
oliglen = int(sys.argv[3])
expInId = intlen/ oliglen
numId = 0
moreInt = 0
c = 0


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
                inId = 1

            elif length < edge:
                inId = 0
                 
            else:
                for n in range(edge,len(sseq)):
                    if sseq[n] == qseq[n]:
                        imat += 1
                inId = imat/length
        
        else:
            edge = intlen - int(qstart)
            if edge < 0:
                inId = 0
            
            elif length < edge:
                inId = 1 

            else:
                for n in range(edge):
                    if sseq[n] == qseq[n]:
                        imat += 1                        
                inId = imat/length

        if inId > expInId:
            moreInt += 1


print(sys.argv[1])
print(numId/c ,"oligos are identical")
print(moreInt/c ,"oligos are id more by inside than outside than we expect")
print(moreInt/(c-numId) ,"oligos are id more by inside than outside than we expect when we exclude identical matches")
print("")


