#!/usr/local/bin/python3.5

import sys

with open(sys.argv[1], "r") as file:
    d={}
    for row in file:
        if row[0] == ">":
            try:
                d[row]+=1
                print(row.rstrip(),"-R")
            except:
                IndexError
                d[row]=1
                print(row.rstrip(),"-L")
        else:
            print(row.rstrip())



