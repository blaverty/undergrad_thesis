#!/usr/local/bin/python3
import sys
import os.path
from itertools import groupby
import re
import mmap

#ishead = lambda x: x.startswith(">")
#
#with open(sys.argv[1]) as infile:
#    keepers = []
#    for head, lines in groupby(infile, ishead):
#        if head:
#            header = (''.join(lines)).rstrip()
#            head = header.split("|")
#                
#        else:
#            check = 0
#            infile= sys.argv[1][:-5]
#            hits = ("").join(lines).rstrip()
#            hits1 = hits.split("\n")
#            for hit in hits1:
#                name = hit.split("\t")[0].split("|")[4]
#                if name not in open('/home/brianne/sepsis2/Card/geneFamily/nucOrder/all/'+infile).read():
#                    check += 1
#            
#            if check == 0:
#                keepers.append(header)
#                keepers.append(hits)
#
#    for x in keepers:
#        print(x)
                
                    
#run listHits first                
            
ishead = lambda x: x.startswith(">")


with open(sys.argv[1]) as infile:
    s = mmap.mmap(infile.fileno(), 0, access=mmap.ACCESS_READ)
    d= {}
    for head, lines in groupby(infile, ishead):
        if head:
            header = (''.join(lines)).rstrip()
            name = header.split("|")[0][1:]
            if name not in d:
                if "." in name:
                    my_regex = "[^>]" + name + "\s[A-Za-z0-9 .&\[\]]+" 
                else:
                    my_regex = "[^>]" + name + ".\d\s[A-Za-z0-9 .&\[\]]+" 
                my_regex_byte = my_regex.encode('utf-8')
                string = re.search(my_regex_byte, s)

#                if string is None:
#                    print(sys.argv[1], name)

                sciname = string.group(0).decode('utf-8').split("\t")[1]
                d[name] = sciname
            
        else:
            check = 0
            infile= sys.argv[1][:-5]
            right_sciname = d[name]
            line = ("").join(lines).rstrip()
            hits = line.split("\n")

            for hit in hits:
                hit = hit.split()
                cur_sciname = hit[1] 
                qseq = hit[2]
                sseq = hit[3]
                length = int(hit[4])
                nident = int(hit[5])
                if length-nident <= 2:
                    #name = hit.split("\t")[0].split("|")[4]
                    #if name not in open('/home/brianne/sepsis2/Card/geneFamily/nucOrder/all/'+infile).read():
                    if cur_sciname != right_sciname:
                    #if name != infile:
                        check += 1
            if check == 0:
                print(header)
                print(line)


                
           
