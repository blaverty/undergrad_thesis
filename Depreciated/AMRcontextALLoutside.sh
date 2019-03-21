#!/bin/

AMRblastALL="$1"

#while read -r line;do
#    array=($line)
#    echo ${array[1]} >> AMRnum
#done < $AMRblastALL

#python3 split.py AMRnum


#for x in AMRsearch.*;do
#filenum=${x##*.}
#echo $filenum
#let "n=0"

# sort AMRblast result by bacteria hit so only have to grep for each
# bacteria

#sort -k2 AMRblastALL > AMRblastALLsort

while read -r line2 ;do
    arr=($line2)
    header=$(echo ${arr[0]}) 
    if [[ ${arr[1]} != $acc ]];then
        acc=${arr[1]}
        file=$(grep -w "$acc" ../../AMRdirTotal | awk '{print $1}')
        if [[ $acc =~ .{4}_. ]] ;then 
            acc=${arr[1]:0:4}
            seq=$(grep -zoP "$acc[^>]+" ../../sequence.fasta/sequence.fasta.$file | sed "1d" | tr -d '\n')     
        else
            seq=$(grep -zowP "^>$acc[^>]+" ../../sequence.fasta/sequence.fasta.$file | sed "1d" | tr -d '\n')     
        fi
    fi
    acc2=$(echo $acc | sed "s/^/>/")
    open="-AMR_gene-"
    header=$acc2$open$(grep "$header" ../../AMRheader | awk '{print $1}')
    size=${#seq}
    #echo $header
    #echo $acc
    #echo $file
    #echo $size
    #echo $seq


    if (( ${arr[3]} > ${arr[2]} ));then
	s1=${arr[2]}
	e2=${arr[3]}
    else
	s1=${arr[3]}
	e2=${arr[2]}
    fi

    

    length=$(($s+100))
    oligo=${seq:0:$length} 
    echo $header | sed "s/$/-L/" >> AMRoligoOutside100
    echo $oligo >> AMRoligoOutside100


    start=$(($e-100))
    length=$(($size - $start))
    oligo=${seq:$e:$length}
    echo $header | sed "s/$/-R/" >> AMRoligoOutside100
    echo $oligo >> AMRoligoOutside100

done < $AMRblastALL
#
#
#
