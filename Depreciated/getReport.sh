#!/bin/

#see if first blast hit is same source as where AMR gene came from in header

#import bc

awk '/>/{x="f5."++i;}{print > x}' "$1"  

#check first blast hit that matches header acc #
#run on refined or original
#for x in f5*;do
#    header=$(head -1 $x)
#    IFS="-" read -r -a array <<< $header
#    acc=${array[1]}
#    grep -A1 ">" $x | grep -P "^$acc" >> f5 
#    rm $x
#done


#check any blast hit that matches header acc #
#run on original
#for x in f5.*;do
#    header=$(head -1 $x)
#    IFS="-" read -r -a array <<< $header
#    acc=${array[1]}
#    grep -P "^$acc" $x >> f5 
#    rm $x
#done


#check blast hits that match word in header
#must run on refined listed blasts with no duplicate hits per AMR gene
#for x in f5.*;do
#    header=$(head -1 $x)
#    if grep -Pqi "vector|uncultured|unculturable|culture|clone|cloned|artificial|mix|mixed" <<< $header; then
#        rm $x
#    else
#        bac=$(grep -Po "\[.+\]" <<< $header | sed 's/\[//;s/\]//;s/-/ /')
#        grep -Pm 1 "^[^>].+$bac" $x >> f5
#        cat $x >> good
#        rm $x
#    fi
#done

   
for x in f5.*;do
    hits=$(wc -l $x | awk '{print $1}') 
    hits=$(($hits-1))
    echo $hits >> report.hitnum
    rm $x
done

#echo "this is excluding AMR genes found in unculturable bacteria" >> report.all.name

#len=$(wc -l $1 | awk '{print $1}')
#len=$(grep -c ">" good)
#num=$(wc -l f5 | awk '{print $1}')
#per=$(echo "scale=3; $num / $len" | bc -l)
#echo $1, $len, $num, $per >> report.all.name  
#rm f5
#rm good


##WRITE SOEMTHING THAT COUNTS NUMBER OF HITS FOR EACH OLIGO
##EVALUATE HOW CLOSE HITS ARE RELATED
##EXCLUDE UNCULTURED BAC HITS BUT NOT AMR GENES CAME FROM UNCULTURED
