#!/usr/local/bin/python3

import sys

c = 0
with open(sys.argv[1]) as f:
    for n,line in enumerate(f):
        if n == 0:
            line = line.split(" ")
            acc1 = line[0]
            s1 = int(line[1])
            e1 = int(line[2])
            aro1 = line[3]
            if e1 < s1:
                s1 = int(line[2])
                e1 = int(line[1])
            l1 = e1 - s1 + 1
    
        else: 
            line = line.split(" ") 
            acc2 = line[0]
            s2 = int(line[1])
            e2 = int(line[2])
            aro2 = line[3]
            if e2 < s2:
                s2 = int(line[2])
                e2 = int(line[1])
            l2 = e2 - s2 + 1
    
            if acc2 == acc1:
                if e1 >= s2 and s1 <= e2:
                    if s1 > s2 and  e1 > e2:
                        o = e1 - s2 + 1 - ((s1 - s2) - (e1 - e2))
                    if s1 > s2 and e1 < e2:
                        o = e1 - s2 + 1 - (s1 - s2)
                    if s1 < s2 and e1 > e2:
                        o = e1 - s2 + 1 - (e1 - e2)
                    if s1 < s2 and e1 < e2:
                        o = e1 - s2 + 1
    
                print(s1, e1, s2, e2)
                if l1 <= l2:
                    p = o/l1
                else:
                    p = o/l2
    
                if p > 0.5 and aro2 != aro1:
                    c += 1
                    print(aro1, aro2)
                    if s2 < s1:
                        s1 = s2
                    if e2 > e1:
                        e1 = e2
                else:
                    acc1 = line[0]
                    s1 = int(line[1])
                    e1 = int(line[2])
                    aro1 = line[3]
                    if e1 < s1:
                        s1 = int(line[2])
                        e1 = int(line[1])
                    l1 = e1 - s1 + 1
            else:
                acc1 = line[0]
                s1 = int(line[1])
                e1 = int(line[2])
                aro1 = line[3]
                if e1 < s1:
                    s1 = int(line[2])
                    e1 = int(line[1])
                l1 = e1 - s1 + 1

    
        print(c)
