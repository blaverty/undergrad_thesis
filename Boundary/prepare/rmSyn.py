#!/usr/local/bin/python3
import sys

#syn = ["vector","artificial","clone","cloning","cloned","synthetic","Vector","Artificial","Clone","Cloning","Cloned","Synthetic"]

syn = ["vector","artificial","clone","cloning","cloned","synthetic","Vector","Artificial","Clone","Cloning","Cloned","Synthetic","uncultured","unculturable","Uncultured","Unculturable","culture"]

with open(sys.argv[1]) as infile:
    for line in infile:
        if not any(x in line for x in syn):
            print(line.rstrip())


#DOESNT WORK
#with open(sys.argv[1]) as infile:
#    for line in infile:
#        if any(x not in line for x in syn):
#            print(line.rstrip())
