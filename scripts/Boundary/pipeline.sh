#!/bin/


while [ $# -eq 1 ];do
    case "$1" in 
        --help | -h)
                echo "on info115 bash pipeline.sh AMRstruct pipedir internal c1 c2 c3 c4"
                exit 0
                ;;
        esac
done



#collapseOverlap.pl -s -m -c -t 0.99 BandS/$1 > BandS/$1col

#mkdir pipe/$2
#
#ExtractContext.pl -s -i $3 -c $4 -p 4 sequence.fasta BandS/$1col > pipe/$2/oligo$4 &
#ExtractContext.pl -s -i $3 -c $5 -p 4 sequence.fasta BandS/$1col > pipe/$2/oligo$5 &
#ExtractContext.pl -s -i $3 -c $6 -p 4 sequence.fasta BandS/$1col > pipe/$2/oligo$6 &
#ExtractContext.pl -s -i $3 -c $7 -p 4 sequence.fasta BandS/$1col > pipe/$2/oligo$7 &
#wait

#selLength.py -l 102 pipe/$2/oligo$4 > pipe/$2/oligo$4L &
#selLength.py -l 128 pipe/$2/oligo$5 > pipe/$2/oligo$5L &
#selLength.py -l 153 pipe/$2/oligo$6 > pipe/$2/oligo$6L &
#selLength.py -l 178 pipe/$2/oligo$7 > pipe/$2/oligo$7L &
#wait
#
#mkdir pipe/$2/blast4
#
#/usr/local/blast/current/bin/blastn -query ~/sepsis2/AMR4/pipe/$2/oligo$4L -out ~/sepsis2/AMR4/pipe/$2/blast4/$4 -db nt -evalue 1e-20 -perc_identity 95 -qcov_hsp_perc 100 -outfmt "6 qseqid saccver qstart qend sstart send staxid ssciname" &
#/usr/local/blast/current/bin/blastn -query ~/sepsis2/AMR4/pipe/$2/oligo$5L -out ~/sepsis2/AMR4/pipe/$2/blast4/$5 -evalue 1e-20 -perc_identity 95 -qcov_hsp_perc 100 -db nt -outfmt "6 qseqid saccver qstart qend sstart send staxid ssciname" &
#/usr/local/blast/current/bin/blastn -query ~/sepsis2/AMR4/pipe/$2/oligo$6L -out ~/sepsis2/AMR4/pipe/$2/blast4/$6 -db nt -evalue 1e-20 -perc_identity 95 -qcov_hsp_perc 100 -outfmt "6 qseqid saccver qstart qend sstart send staxid ssciname" &
#/usr/local/blast/current/bin/blastn -query ~/sepsis2/AMR4/pipe/$2/oligo$7L -out ~/sepsis2/AMR4/pipe/$2/blast4/$7 -evalue 1e-20 -perc_identity 95 -qcov_hsp_perc 100 -db nt -outfmt "6 qseqid saccver qstart qend sstart send staxid ssciname" &
#wait

rmSyn.py pipe/$2/blast4/$4 > pipe/$2/blast4/$4N &
#rmSyn.py pipe/$2/blast4/$5 > pipe/$2/blast4/$5N &
#rmSyn.py pipe/$2/blast4/$6 > pipe/$2/blast4/$6N &
#rmSyn.py pipe/$2/blast4/$7 > pipe/$2/blast4/$7N &
wait

length=$(($3+$4))
collapseBlast.py -t pipe/$2/blast4/$4tmp -l $length pipe/$2/blast4/$4N & 
#length=$(($3+$5))
#collapseBlast.py -t pipe/$2/blast4/$5tmp -l $length pipe/$2/blast4/$5N & 
#length=$(($3+$6))
#collapseBlast.py -t pipe/$2/blast4/$6tmp -l $length pipe/$2/blast4/$6N &  
#length=$(($3+$7))
#collapseBlast.py -t pipe/$2/blast4/$7tmp -l $length pipe/$2/blast4/$7N & 
wait

sort -T ~/tmp2 pipe/$2/blast4/$4tmp | collapseOverlap.pl -f " " -m -s -t 0.99 /dev/stdin > pipe/$2/blast4/$4Ncol &
#wait
#sort -T ~/tmp2 pipe/$2/blast4/$5tmp | collapseOverlap.pl -f " " -m -s -t 0.99 /dev/stdin > pipe/$2/blast4/$5Ncol &
#wait
#sort -T ~/tmp2 pipe/$2/blast4/$6tmp | collapseOverlap.pl -f " " -m -s -t 0.99 /dev/stdin > pipe/$2/blast4/$6Ncol &
#wait
#sort -T ~/tmp2 pipe/$2/blast4/$7tmp | collapseOverlap.pl -f " " -m -s -t 0.99 /dev/stdin > pipe/$2/blast4/$7Ncol &
wait

rm pipe/$2/blast4/$4tmp &
#rm pipe/$2/blast4/$5tmp &
#rm pipe/$2/blast4/$6tmp &
#rm pipe/$2/blast4/$7tmp &
wait

mkdir pipe/$2/blast4/listHits

bash listHits.sh pipe/$2/blast4/$4Ncol pipe/$2/blast4/$4tmp3 > pipe/$2/blast4/listHits/$4 &
#bash listHits.sh pipe/$2/blast4/$5Ncol pipe/$2/blast4/$5tmp3 > pipe/$2/blast4/listHits/$5 &
#bash listHits.sh pipe/$2/blast4/$6Ncol pipe/$2/blast4/$6tmp3 > pipe/$2/blast4/listHits/$6 &
#bash listHits.sh pipe/$2/blast4/$7Ncol pipe/$2/blast4/$7tmp3 > pipe/$2/blast4/listHits/$7 &
wait 

mkdir pipe/$2/blast4/listHits/lin

getLin.py pipe/$2/blast4/listHits/$4  > pipe/$2/blast4/listHits/lin/$4 &
#getLin.py pipe/$2/blast4/listHits/$5  > pipe/$2/blast4/listHits/lin/$5 &
#getLin.py pipe/$2/blast4/listHits/$6  > pipe/$2/blast4/listHits/lin/$6 &
#getLin.py pipe/$2/blast4/listHits/$7  > pipe/$2/blast4/listHits/lin/$7 &
wait

rmDupAROlist.py pipe/$2/blast4/listHits/lin/$4  > pipe/$2/blast4/listHits/lin/$4aro &
#rmDupAROlist.py pipe/$2/blast4/listHits/lin/$5  > pipe/$2/blast4/listHits/lin/$5aro &
#rmDupAROlist.py pipe/$2/blast4/listHits/lin/$6  > pipe/$2/blast4/listHits/lin/$6aro &
#rmDupAROlist.py pipe/$2/blast4/listHits/lin/$7  > pipe/$2/blast4/listHits/lin/$7aro &
wait

mkdir pipe/$2/blast4/listHits/lin/deep

deepClade.py pipe/$2/blast4/listHits/lin/$4aro  > pipe/$2/blast4/listHits/lin/deep/$4 &
#deepClade.py pipe/$2/blast4/listHits/lin/$5aro  > pipe/$2/blast4/listHits/lin/deep/$5 &
#deepClade.py pipe/$2/blast4/listHits/lin/$6aro  > pipe/$2/blast4/listHits/lin/deep/$6 &
#deepClade.py pipe/$2/blast4/listHits/lin/$7aro  > pipe/$2/blast4/listHits/lin/deep/$7 &
wait


bash reportClade.sh pipe/$2/blast4/listHits/lin/deep/$4 $4 > pipe/$2/blast4/listHits/lin/deep/report &
wait
#bash reportClade.sh pipe/$2/blast4/listHits/lin/deep/$5 $5 >> pipe/$2/blast4/listHits/lin/deep/report &
#wait
#bash reportClade.sh pipe/$2/blast4/listHits/lin/deep/$6 $6 >> pipe/$2/blast4/listHits/lin/deep/report &
#wait
#bash reportClade.sh pipe/$2/blast4/listHits/lin/deep/$7 $7 >> pipe/$2/blast4/listHits/lin/deep/report &

