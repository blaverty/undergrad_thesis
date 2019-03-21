#!/bin/

# pwd is AMRblast
# for x in *;do bash ../listHits.sh $x > ../listHits/$x; done
# reads AMRblast file and outputs header of AMRgene and list of
# accession # that the gene hits on blast and a definition of what
# that # leads to


awk '{split($1,a,"|"); printf "%s|%s|%s|%s|%s\t",a[1],a[2],a[3],a[4],a[5]; printf "%s\t", a[6]}{for (i=4;i<=(NF-1);i++) printf "%s ", $i}{print $NF}' $1 > $2

awk '!seen[$1]++{print ">" $1}{printf "%s\t%s\t", $2,$3; for (i=4;i<=(NF-1); i++) printf "%s ", $i; print $NF}' $2
#awk '!seen[$1]++{print ">" $1}{printf "%s\t%s\t", $2,$7; for (i=8;i<=(NF-1); i++) printf "%s ", $i; print $NF}' $1
rm $2
