#!/bin/

while read -r line;do
    #ar=($line)
    #acc=${ar[1]}
    if grep -q "$line" filenames;then
        continue
        #echo "$line found"
    else
        echo "$line"
    fi
done < $1
