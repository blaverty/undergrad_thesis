#!/bin/

ACC=$1
echo -n -e "$ACC\t"
curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=${ACC}&rettype=fasta&retmode=xml" |\
grep TSeq_taxid |\
cut -d '>' -f 2 |\
cut -d '<' -f 1 |\
tr -d "\n"
echo
