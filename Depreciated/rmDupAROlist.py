#!/usr/local/bin/python3

import sys
import re

for line in open(sys.argv[1]):
    if line[0] == ">":
        line = line.split("|")
        aro = line[4]
        aronew = re.sub("ARO:","",aro)
        dup = (aronew.rstrip()).split(";")
        one = set()
        for x in dup:
            if x not in one:
                one.add(x)
        arofinal = [y for y in one]
        line[4] = ";".join(arofinal)
        print("|".join(line).rstrip())
    else:
        print(line.rstrip())

            


