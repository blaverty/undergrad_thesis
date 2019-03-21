#!/usr/local/bin/python3

import sys
from itertools import groupby

ishead = lambda x: x.startswith(">")

with open(sys.argv[1]) as infile:
    d = {}
    c = 0
    for h, lines in groupby(infile, ishead):
        if h:
            c += 1
            d={}
            head = (''.join(lines)).rstrip()
            head = head.split(":")[2:]
            head = (",").join(head)
            head = head.split(",")
            if head[0] == '0':
                c -= 1
                continue
            else:
                for x in range(len(head)):
                    if x%2 == 0:
                        d[head[x]] = int(head[x+1])
            #print(d)
        
        else:
            hits = (" ").join(lines)
            for y in d.keys():
                if y in hits:
                    print("hit", d[y], y)
                else:
                    print("no", d[y], y)
    if c != 0:
        print(c)

