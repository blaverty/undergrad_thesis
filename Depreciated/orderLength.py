#!/usr/bin/python

#order fasta files of AMR gene families by size from largest to
#smallest to make list of fasta in size order for usearch

from itertools import groupby
import sys

if __name__ == '__main__':
    ishead = lambda x: x.startswith('>')
    d = {}

    with open(sys.argv[1]) as handle:
        head = None
        for h, lines in groupby(handle, ishead):
            if h:
                head = lines.next()
            else:
                seq = ''.join(lines)
                d[head] = seq


        while len(d) != 0:
            maxi = max((len(v),k) for k,v in d.items())
            print(maxi[1].rstrip())
            print(d[maxi[1]].rstrip())
            del d[maxi[1]]
