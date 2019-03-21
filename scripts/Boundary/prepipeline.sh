#!/bin/

/usr/local/blast/current/bin/blastn -query ~/sepsis2/AMR4/$1 -out ~/sepsis2/AMR4/BandS/$2 -db nt -qcov_hsp_perc 100 -evalue 1e-20 -perc_identity 90 -outfmt "6 qseqid saccver qseq sseq sstart send length qcovs staxid ssciname evalue"
wait

~/sepsis2/AMR4/rmSyn.py ~/sepsis2/AMR4/BandS/$2 > ~/sepsis2/AMR4/BandS/$2NoSyn
wait

sort -k 2 ~/sepsis2/AMR4/BandS/$2NoSyn > ~/sepsis2/AMR4/BandS/$2NoSynSort 
wait

bash ~/sepsis2/AMR4/genContextInputAMRblast.sh ~/sepsis2/AMR4/BandS/$2NoSynSort > ~/sepsis2/AMR4/BandS/AMRstruct$2  
wait

bash ~/sepsis2/AMR4/insARO.sh ~/sepsis2/AMR4/arolist ~/sepsis2/AMR4/BandS/AMRstruct$2
wait

~/sepsis2/AMR4/collapseOverlap.pl -s -m -c -t 0.99 ~/sepsis2/AMR4/BandS/AMRstruct$2 > ~/sepsis2/AMR4/BandS/AMRstruct$2col

