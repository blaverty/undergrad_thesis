#!/usr/local/bin/python3

import sys
from itertools import groupby

#i = 0
#with open(sys.argv[1], "r") as infile:
#    head = lambda x: x.startswith(">")
#    for key, group in groupby(infile, head):
#        if key:
#            i += 1
#        with open("file.%s" % i, "w") as outfile:
#            if key:
#                header = ''.join(group)
#            else:
#                lines = ''.join(group)
#                outfile.write(header) 
#                outfile.write(lines) 
#
#
#
#path = "/home/brianne/sepsis2/AMR4/t/file*"
#for filename in glob.glob(path):
#    d = {7: "strain", 6: "species", 5: "genus", 4: "family",
#            3: "order", 2: "class", 1: "phylum", 0:
#            "superkingdom"}
#    with open(filename, 'r') as f:
#        lists = []
#        for x, line in enumerate(f):
#            if x == 0:
#                print(line.rstrip(), end="     ", flush=True)
#            if x > 0:
#                lists.append(line.split(" , ")[2:])
#        group = list(zip(*lists))
#                   
#        for i, e in reversed(list(enumerate(group))):
#            r = 0
#            if all(j == e[0] for j in e):
#                print(d[i])
#                break
#        if i == 0:
#            print("NONE")
#        os.remove(filename)




with open(sys.argv[1], "r") as infile:
    head = lambda x: x.startswith(">")
    for key, group in groupby(infile, head):
        d = {7: "species2 species genus family order class phylum superkingdom", 6: "species genus family order class phylum superkingdom", 5: "genus family order class phylum superkingdom", 4: "family order class phylum superkingdom", 3: "order class phylum superkingdom", 2: "class phylum superkingdom", 1: "phylum superkingdom", 0: "superkingdom"}
        if key:
            header = ''.join(group)
            print(header.rstrip(), end="     ", flush=True)
        else:
            lists = []
            for line in group:
                lists.append(line.split(" , ")[1:])
            group = list(zip(*lists))
                   
        for i, e in reversed(list(enumerate(group))):
            if all(j == e[0] for j in e):
                print(d[i])
                break
            if i == 0:
                print("NONE")
