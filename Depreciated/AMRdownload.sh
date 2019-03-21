#!/bin/
# take BLAST result of AMR genes and download organisms that genes hit

# bash AMRdownload.sh AMRblast AMRgenes

AMRblast="$1"
AMRgenes="$2"
        
grep Query= "$AMRblast" | sed -e 's/Query= //' >> AMRname
grep -A 2 Value "$AMRblast" | sed '/^$/d; /--$/d; /Sequences/d' >> tmp

while read -r line;do
    arr=($line)
    echo ${arr[0]} >> AMRnum 
done < tmp 

#rm tmp

while read -r line2;do
    echo ">$line2" >> AMRNCBI
    let "n+=1"
    sed "${n}q;d" AMRnum >> AMRNCBI
done < AMRname

#rm AMRname
#rm AMRnum

while read -r line3;do
    array=($line3)
    if [ ${array[0]:0:1} == ">" ];then
        echo $line3 >> AMRgenesF75
    else
        echo ${array[0]:0:75} >> AMRgenesF75
        #echo ${array[0]:(-75)}
    fi
done < "$AMRgenes"


while read -r line4;do
    ar=($line4)
    if [ ${ar[0]:0:1} == ">" ];then
        echo $line4
        let "m+=2"
        acc=$(sed "${m}q;d" AMRNCBI)
        seq75=$(sed "${m}q;d" AMRgenesF75)
        seq75=$(echo $seq75 | sed "s/\(.\)/\\\s?\1\\\s?/g")         
        grep -zoP "$acc[^>]+" sequence.fasta >> tmp2
        sed -i '1d' tmp2
        sed -i '1i>' tmp2
        grep -zoP "[^>]{0,50}$seq75" tmp2 | tr -d '\n'| sed 's/$/\n/'
        rm tmp2
    fi
done < AMRgenesF75

