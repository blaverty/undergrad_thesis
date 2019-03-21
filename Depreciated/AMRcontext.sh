#!/bin/


# make 75bp oligos from ends AMR genes with additional 25bp, 50bp,
# 75bp, 100bp regions of context
# outputs genes into files labeled for length
# outputs to "AMRoligoOther" are when oligo cannot be extended to
# desired length, file header format is "unique header:size of
# oligo:number of bp extension desired that cannot be done"

AMRgenes="$1"
while read -r line;do
    IFS="|"
    array=($line)
    if [ ${array[0]:0:1} == ">" ];then
        echo ${array[1]} >> AMRnum
        echo ${array[1]}-${array[3]}  >> AMRsearch
        echo $line | sed "s/ /-/g;s/+/-/;s/:/-/" >> AMRheaders
    fi
done < $AMRgenes

rm AMRnum

while read -r line2 ;do
    IFS="-"
    arr=($line2)
    acc=${arr[0]}
    seq=$(grep -zoP "$acc[^>]+" sequence.fasta | sed "1d" | tr -d '\n')
    size=${#seq}
    let "n+=1"
    #echo $size
    #echo $seq

    s1=${arr[1]}
    e1=$(($s1 + 74))
    e2=${arr[2]}
    s2=$(($e2 - 75))
    OligoS=${seq:$s1 -1:75}
    OligoE=${seq:$s2:75}
    #echo $OligoS
    #echo $OligoE





    s25=$(($s1 - 25))
    if (($s25 < 0));then
        add=$((0 - $s25 + 1))
        oligo=${seq:0:$e1} 
        sed "${n}q;d" AMRheaders | sed "s/$/-L-${#oligo}-$add/" >> AMRoligoOther
        echo $oligo >> AMRoligoOther
    else
        oligo=${seq:$s25:100}
        sed "${n}q;d" AMRheaders | sed "s/$/-L/" >> AMRoligo25
        echo $oligo >> AMRoligo25
    fi


    e25=$(($e2 + 25))
    if (($e25 > $size));then
        add=$(($e25 - $size))
        diff=$(($size - $s2))
        oligo=${seq:$s2:$diff}
        sed "${n}q;d" AMRheaders | sed "s/$/-R-${#oligo}-$add/" >> AMRoligoOther
        echo $oligo >> AMRoligoOther
    else
        oligo=${seq:$s2:100}
        sed "${n}q;d" AMRheaders | sed "s/$/-R/" >> AMRoligo25
        echo $oligo >> AMRoligo25
    fi




    s50=$(($s1 - 50))
    if (($s50 < 0));then
        add=$((0 - $s50 + 1))
        oligo=${seq:0:$e1}
        sed "${n}q;d" AMRheaders | sed "s/$/-L-${#oligo}-$add/">> AMRoligoOther
        echo $oligo >> AMRoligoOther
    else
        oligo=${seq:$s50:125}
        sed "${n}q;d" AMRheaders | sed "s/$/-L/" >> AMRoligo50
        echo $oligo >> AMRoligo50
    fi

    
    e50=$(($e2 + 50))
    if (($e50 > $size));then
        add=$(($e50 - $size))
        diff=$(($size - $s2))
        oligo=${seq:$s2:$diff}
        sed "${n}q;d" AMRheaders | sed "s/$/-R-${#oligo}-$add/">> AMRoligoOther
        echo $oligo >> AMRoligoOther
    else
        oligo=${seq:$s2:125}
        sed "${n}q;d" AMRheaders | sed "s/$/-R/" >> AMRoligo50
        echo $oligo >> AMRoligo50
    fi




    s75=$(($s1 - 75))
    if (($s75 < 0));then
        add=$((0 - $s25 + 1))
        oligo=${seq:0:$e1} 
        sed "${n}q;d" AMRheaders | sed "s/$/-L-${#oligo}-$add/" >> AMRoligoOther
        echo $oligo >> AMRoligoOther
    else
        oligo=${seq:$s75:150}
        sed "${n}q;d" AMRheaders | sed "s/$/-L/" >> AMRoligo75
        echo $oligo >> AMRoligo75
    fi


    e75=$(($e2 + 75))
    if (($e75 > $size));then
        add=$(($e75 - $size))
        diff=$(($size - $s2))
        oligo=${seq:$s2:$diff}
        sed "${n}q;d" AMRheaders | sed "s/$/-R-${#oligo}-$add/" >> AMRoligoOther
        echo $oligo >> AMRoligoOther
    else
        oligo=${seq:$s2:150}
        sed "${n}q;d" AMRheaders | sed "s/$/-R/" >> AMRoligo75
        echo $oligo >> AMRoligo75
    fi




    s100=$(($s1 - 100))
    if (($s100 < 0));then
        add=$((0 - $s100 + 1))
        oligo=${seq:0:$e1}
        sed "${n}q;d" AMRheaders | sed "s/$/-L-${#oligo}-$add/">> AMRoligoOther
        echo $oligo >> AMRoligoOther
    else
        oligo=${seq:$s100:175}
        sed "${n}q;d" AMRheaders | sed "s/$/-L/" >> AMRoligo100
        echo $oligo >> AMRoligo100
    fi


    e100=$(($e2 + 100))
    if (($e100 > $size));then
        add=$(($e100 - $size))
        diff=$(($size - $s2))
        oligo=${seq:$s2:$diff}
        sed "${n}q;d" AMRheaders | sed "s/$/-R-${#oligo}-$add/">> AMRoligoOther
        echo $oligo >> AMRoligoOther
    else
        oligo=${seq:$s2:175}
        sed "${n}q;d" AMRheaders | sed "s/$/-R/" >> AMRoligo100
        echo $oligo >> AMRoligo100
    fi


done < AMRsearch

rm AMRsearch
rm AMRheaders


