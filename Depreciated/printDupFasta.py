#!/usr/bin/python

from itertools import groupby
import sys

if __name__ == '__main__':

    ishead = lambda x: x.startswith('>')
    all_seqs = set()
    d = {}
    with open(sys.argv[1]) as handle:
        head = None
        for h, lines in groupby(handle, ishead):
            if h:
                head = lines.next()
            else:
                seq = ''.join(lines)
                if seq not in all_seqs:
                    all_seqs.add(seq)
                    d[seq] = head
                    #print head, seq.rstrip()
                else:
                    print(d[seq].rstrip())
                    print(head)
