#!/bin/

#list snp hits
#geneFamily

awk '!seen[$1]++{print ">" $1}{printf "%s\t%s\t%s\t%s\t%s\n", $2, $3, $4, $5, $6}' $1

