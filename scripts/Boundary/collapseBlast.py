#!/usr/local/bin/python3

import sys
import subprocess
import argparse

parser = argparse.ArgumentParser(description="pre process oligo blast hits for collapse overlap")
parser.add_argument("-t", "--tmp",  help="tmp file name")
parser.add_argument("-l", "--length",  help="length of oligo", type=int)
parser.add_argument("filename", nargs="+")
args = parser.parse_args()

length=args.length
with open(args.tmp,'w') as tmp:
    for line in open(sys.argv[5]):
        line = line.split("\t")
        qs=int(line[2])
        ss=int(line[4])
        newS=ss-qs
        newE=newS + length
        head=[line[0],line[1]]
        newhead="|".join(head)
        newline=[newhead,str(newS),str(newE),line[6],line[7]]
        tmp.write("\t".join(newline))

#with open(args.tmp2,'w') as tmp2:
#    cmd = ["sort",args.tmp]
#    subprocess.call(cmd,stdout=tmp2)
#subprocess.call(["/home/brianne/sepsis2/AMR4/collapseOverlap.pl","-s","-f"," ","-m","-t","0.99", args.tmp2])

#subprocess.call(["rm",args.tmp])
#subprocess.call(["rm",args.tmp2])
