#!/usr/local/bin/python3

import sys
import argparse

parser = argparse.ArgumentParser(description="calculate score to evaluate percentage of oligos whose blast hit is influenced more by the internal region of the AMR gene than expected")
parser.add_argument("-i", "--internal",  help="internal amount of AMR gene in oligos", type=int)
parser.add_argument("-l", "--length",  help="length of oligos", type=int)
parser.add_argument("filename", nargs="+")
args = parser.parse_args()

perExp = args.internal/args.length
count = 0 
numId = 0
#print(args.internal, args.length, perExp)

with open(sys.argv[5]) as infile:
    for line in infile:
        perIn = None
        row = line.split()
        if int(row[3]) > int(row[2]):
            s = int(row[2])
            e = int(row[3])        
        else:
            e = int(row[2])        
            s = int(row[3]) 
        lenHit = e - s 
       #print(s,e) 
        if s == 1 and e == args.length:
            perIn = args.internal/ args.length
            numId += 1
        else:
            if "down" not in row[0]:
                i = args.length - args.internal
                if e > i:
                    if s < i:
                        perIn = (e - i)/ lenHit
                    else:
                        perIn = 1
                else:
                    perIn = 0
        
            else:
                if s < args.internal:
                    if e > args.internal:
                        perIn = (args.internal - s)/ lenHit
                    else:
                        perIn = 1
                else:
                    perIn = 0
        
        if perIn > perExp:
            count += 1

        #print(perIn,perExp,count)
        #print("\n")
    numlines = sum(1 for line in open(sys.argv[5]))
    score = (count/ numlines)*100
    perId = (numId/ numlines)*100
    try:
        score2 = (count/ (numlines - numId))*100
    except:
        ZeroDivisionError
        score2 = 0
    print(str(score) + "% of total oligo hits are identified more by the inside than outside than we expected")
    print(str(perId) + "% oligo hits are identified by the whole oligo")
    print(str(score2) + "% oligo hits excluding hits identified by the whole oligo are identified more by the inside than outiside than we expected")
            
        
