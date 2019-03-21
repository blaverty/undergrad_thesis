#!/usr/local/bin/python3

import sys
from itertools import groupby

ishead = lambda x: x.startswith(">")
ispos = lambda y: type(y) == int

with open(sys.argv[1]) as infile:
    for head, lines in groupby(infile, ishead):
        if head:
            header = (''.join(lines)).rstrip()
            head = header.split("|")
            snp = head[2]
            div = head[3]
            names = set()
            if snp != "{}":
                char_to_remove = ["{","}","[","]", "'", "(", ")"]
                sc = set(char_to_remove)
                snp = ''.join([c for c in snp if c not in sc])
                snp = snp.replace("ARO:","ARO;")
                snp = snp.split(":")
                snp = (",").join(snp)
                snp = snp.split(",")
                for n,x in enumerate(snp):
                    try:
                        snp[n] = int(x)
                    except ValueError:
                        if len(x) != 1:
                            names.add(x.replace("ARO;",""))
            
            else:
                continue

            char_to_remove = ["'", "[", "]"]
            sc = set(char_to_remove)
            div = ''.join([c for c in div if c not in sc])
            div = div.split(",")


        else:
            if names != set():
                print(header)
                hits = ("").join(lines).rstrip()
                for name in names:
                    if name in hits:
                        print("ARO:"+name, "hitt")
                    else:
                        print(name, "not")
            
                for othname in div:
                    if othname in hits:
                        print(othname, "divhit")
           
                hits = hits.split('\n') 

                fasta = sys.argv[1][:-5]
                for hit in hits:
                    namenot = hit.split()[0].split("|")
                    namenot = namenot[4]
                    if namenot not in names:
                        if namenot not in div:
                            if namenot not in open('/home/brianne/sepsis2/Card/geneFamily/nucOrder/85/'+fasta).read():
                                print(namenot, "ranhit")
                
                    
                    
