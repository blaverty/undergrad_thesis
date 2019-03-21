#!/usr/local/bin/python3
import sys
from itertools import groupby


#from list to remove and list of all

#rem = []
#for line in  open(sys.argv[1]):
#   rem.append(line) 
#   
#
#ishead = lambda x: x.startswith(">")
#
#with open(sys.argv[2]) as infile:
#    for head, lines in groupby(infile, ishead):
#        if head:
#            header = (''.join(lines))
#                
#        else:
#            seq = ("").join(lines).rstrip()
#            #seq = seq.replace("\n","")
#            if header not in rem:
#                print(header.rstrip())
#                print(seq)


#from list to keep and list of all
#compOligos.py finallist finaloligo_nohuman_header

ishead = lambda x: x.startswith(">")

hits = {}
with open(sys.argv[1]) as infile:
    for head, lines in groupby(infile, ishead):
        if head:
            header = (''.join(lines))
                
        else:
            list_hits = ("").join(lines).rstrip()
            hits[header] = list_hits

for oligo_head in  open(sys.argv[2]):
    if oligo_head in hits.keys():
        print(oligo_head.rstrip())
        print(hits[oligo_head]) 
