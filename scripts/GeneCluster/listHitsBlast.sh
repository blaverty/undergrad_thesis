#!/bin/

#make snp host groups

#awk '{split($1,a,"|"); printf "%s|%s|%s|%s|%s\t",a[1],a[2],a[3],a[4],a[5]}{for (i=2;i<=(NF-1);i++) printf "%s ", $i}{print $NF}' $1 > $2
#
#awk '!seen[$1]++{print ">" $1}{printf "%s\t%s\t%s\t%s\t", $2, $3, $4,
#$5; for (i=6;i<=(NF-1); i++) printf "%s ", $i; print $NF}' $2
#
#rm $2


#list snp hits

#geneHost
#awk '!seen[$1]++{print ">" $1}{printf "%s\t", $2; for (i=10; i<=(NF-1); i++) printf "%s&", $i; printf "%s\t", $NF ;printf "%s\t%s\t%s\t%s\t%s\n", $3, $4, $5, $6, $9}' $1

#geneFamily
awk '!seen[$1]++{print ">" $1}{printf "%s\t%s\t%s\t%s\t%s\n", $2, $3, $4, $5, $6}' $1


#list oligo hits

#awk '!seen[$1]++{print ">" $1}{printf "%s|%s-%s|%s|", $2, $4, $5, $9; for (i=10; i<=(NF-1); i++) printf "%s&", $i; printf "%s\t%s\n", $NF, $3}' $1


#blast4 in geneHost
#evalue 1e-20
#perc_identity 95
#qcov_hsp_perc 100
#qseqid saccver sseq sstart send pident qcovhsp evalue staxid ssciname
