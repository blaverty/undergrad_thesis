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
    header=$(echo ${arr[0]} | sed "s/|/-/g;s/+/-/;s/:/-/;s/^/>/")
    if [[ ${arr[1]} != $acc ]];then
        acc=${arr[1]}
        file=$(grep -w "$acc" ../../../AMRdirTotal | awk '{print $1}')
        if [[ $acc =~ .{4}_. ]] ;then 
            acc=${arr[1]:0:4}
            seq=$(grep -zoP "$acc[^>]+" ../../../sequence.fasta/sequence.fasta.$file | sed "1d" | tr -d '\n')     
        else
            seq=$(grep -zowP "$acc[^>]+" ../../../sequence.fasta/sequence.fasta.$file | sed "1d" | tr -d '\n') 
        fi
    fi
    header=$header-$acc
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

   

#    if [[ (${arr[2]} == *";"* ) || ( ${arr[3]} == *";"* ) ]];then
#        IFS=";"
#        snum=(${arr[2]})
#        enum=(${arr[3]})
#        if ((${enum[0]} > ${snum[0]} ));then
#            s1=${snum[0]}
#            e2=${enum[0]}
#        else
#            e2=${snum[0]}
#            s1=${enum[0]}
#        fi
#
#    else
#	if (( ${arr[3]} > ${arr[2]} ));then
#	    s1=${arr[2]}
#	    e2=${arr[3]}
#	else
#	    s1=${arr[3]}
#	    e2=${arr[2]}
#	fi
#    fi


    #echo $s1,$e2
    e1=$(($s1 + 74))
    s2=$(($e2 - 75))
    #echo $s1,$e1
    #echo $s2,$e2
    #OligoS=${seq:$s1-1:75}
    #OligoE=${seq:$s2:75}
    #echo "seqS"
    #echo $OligoS
    #echo "seqE"
    #echo $OligoE



    s25=$(($s1 - 25))
    if (($s25 < 0));then
        add=$((0 - $s25 + 1))
        oligo=${seq:0:$e1} 
        echo $header | sed "s/$/-L-${#oligo}-$add/" >> AMRoligoOther
        echo $oligo >> AMRoligoOther
    else
        oligo=${seq:$s25-1:100}
        echo $header | sed "s/$/-L/" >> AMRoligo25
        echo $oligo >> AMRoligo25
    fi


    e25=$(($e2 + 25))
    if (($e25 > $size));then
        add=$(($e25 - $size))
        diff=$(($size - $s2))
        oligo=${seq:$s2:$diff}
        echo $header | sed "s/$/-R-${#oligo}-$add/" >> AMRoligoOther
        echo $oligo >> AMRoligoOther
    else
        oligo=${seq:$s2:100}
        echo $header | sed "s/$/-R/" >> AMRoligo25
        echo $oligo >> AMRoligo25
    fi




    s50=$(($s1 - 50))
    if (($s50 < 0));then
        add=$((0 - $s50 + 1))
        oligo=${seq:0:$e1}
        echo $header | sed "s/$/-L-${#oligo}-$add/" >> AMRoligoOther
        echo $oligo >> AMRoligoOther
    else
        oligo=${seq:$s50-1:125}
        echo $header | sed "s/$/-L/" >> AMRoligo50
        echo $oligo >> AMRoligo50
    fi

    
    e50=$(($e2 + 50))
    if (($e50 > $size));then
        add=$(($e50 - $size))
        diff=$(($size - $s2))
        oligo=${seq:$s2:$diff}
        echo $header | sed "s/$/-R-${#oligo}-$add/" >> AMRoligoOther
        echo $oligo >> AMRoligoOther
    else
        oligo=${seq:$s2:125}
        echo $header | sed "s/$/-R/" >>AMRoligo50
        echo $oligo >> AMRoligo50
    fi




    s75=$(($s1 - 75))
    if (($s75 < 0));then
        add=$((0 - $s75 + 1))
        oligo=${seq:0:$e1} 
        echo $header | sed "s/$/-L-${#oligo}-$add/" >> AMRoligoOther
        echo $oligo >> AMRoligoOther
    else
        oligo=${seq:$s75-1:150}
        echo $header | sed "s/$/-L/" >> AMRoligo75
        echo $oligo >> AMRoligo75
    fi


    e75=$(($e2 + 75))
    if (($e75 > $size));then
        add=$(($e75 - $size))
        diff=$(($size - $s2))
        oligo=${seq:$s2:$diff}
        echo $header | sed "s/$/-R-${#oligo}-$add/" >> AMRoligoOther
        echo $oligo >> AMRoligoOther
    else
        oligo=${seq:$s2:150}
        echo $header | sed "s/$/-R/" >> AMRoligo75
        echo $oligo >> AMRoligo75
    fi




    s100=$(($s1 - 100))
    if (($s100 < 0));then
        add=$((0 - $s100 + 1))
        oligo=${seq:0:$e1}
        echo $header | sed "s/$/-L-${#oligo}-$add/">> AMRoligoOther
        echo $oligo >> AMRoligoOther
    else
        oligo=${seq:$s100-1:175}
        echo $header | sed "s/$/-L/" >> AMRoligo100
        echo $oligo >> AMRoligo100
    fi


    e100=$(($e2 + 100))
    if (($e100 > $size));then
        add=$(($e100 - $size))
        diff=$(($size - $s2))
        oligo=${seq:$s2:$diff}
        echo $header | sed "s/$/-R-${#oligo}-$add/" >> AMRoligoOther
        echo $oligo >> AMRoligoOther
    else
        oligo=${seq:$s2:175}
        echo $header | sed "s/$/-R/" >>AMRoligo100
        echo $oligo >> AMRoligo100
    fi

done < $AMRblastALL
#
#
#
