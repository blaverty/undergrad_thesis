#!/usr/local/bin/python3

import sys

for line in open(sys.argv[1]):
    if line[0:8] == "##contig":
        length = str(line[22:-2])
        print(length)
    elif line[0:2] == "##":
        continue
    elif line[0:6] == "#CHROM":
        line = line.rstrip()
        colnames = line.split("\t")
    else:
        line = line.split("\t")
        line[-1] = line[-1].rstrip()
        snp = line[9:]
        line4 = line[4].split(",")
        line4.insert(0,line[3])
        for x in range(len(line4)):
            c = snp.count(str(x))
            if c == 1:
                for n,y in enumerate(snp):
                    if x == int(y):
                        print("%s\t%s\t%s\t%s" % (colnames[n+9], line[1],
                            line[3], line4[x]))
            elif c == 0:
                continue
            else:
                for n,y in enumerate(snp):
                    if x == int(y):
                        print("%s\t%s\t%s\t%s\t%s" % (colnames[n+9], line[1],
                            line[3], line4[x], "OTHERSNP"))
