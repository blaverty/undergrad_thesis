#!/usr/local/bin/python3
import sys
from itertools import groupby
import re
import mmap

bad = ["vector","artificial","clone","cloning","cloned","synthetic","Vector","Artificial","Clone","Cloning","Cloned","Synthetic","uncultured","unculturable","Uncultured","Unculturable","culture"]

ishead = lambda x: x.startswith(">")


with open(sys.argv[1]) as infile:
    s = mmap.mmap(infile.fileno(), 0, access=mmap.ACCESS_READ)
    d = {}
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
                sciname = string.group(0).decode('utf-8').split("\t")[1]
                for x in bad:
                        if x in sciname:
                            sciname = "Thiswillnotmatch"
                d[name] = sciname

        else:
            if d[name] == "Thiswillnotmatch":
                continue
            line = ("").join(lines).rstrip()
            hits = line.split("\n")
            check_head = 0

            for hit in hits:
                if not any(x in hit for x in bad):
                    if check_head == 0:
                        print(header) 
                    check_head = 1
                    print(hit.rstrip())

