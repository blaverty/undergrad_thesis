#!/usr/local/bin/python3

from itertools import groupby
import sys

arolist = [x.rstrip() for x in open(sys.argv[2])]

c = 0
ishead = lambda x: x.startswith('>')
with open(sys.argv[1]) as f:
    for h, lines in groupby(f, ishead):
        if h:
            head = ''.join(lines).rstrip()
            aro = head.split("|")[4].split(";")
            if not any(y in aro for y in arolist):
                c = True
            else:
                c = False
        else:
            if c == True:
                listhit = ''.join(lines)
                print(head)
                print(listhit.rstrip())

