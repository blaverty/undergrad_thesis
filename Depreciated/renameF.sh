#!/bin/

#rename split fasta files to accession number


for x in AMRfasta* ;do
    header=$(head -1 $x | awk '{print $1}' | sed 's/>//')
    rename $x $header $x
done
