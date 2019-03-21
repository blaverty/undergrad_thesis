#!/bin/

#bash insARO.sh arolist AMRstruct  


#awk 'BEGIN{FS="|"}{print $5}' $1 | sed 's/ARO://'  > tmp


while read -r line; do
    arr=($line)
    sed -i "s/ARO:${arr[0]}/${arr[0]};${arr[1]}/g" $2
done < $1


