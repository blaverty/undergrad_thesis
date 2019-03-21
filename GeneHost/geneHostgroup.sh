#!/bin/

while read -r line;do
    if [[ "$line" == ">"* ]]; then
        IFS="|"
        arr=($line)
        name=${arr[4]}
        name="${name//ARO:/}"
    else
        unset IFS
        arr=($line)
        printf ">%s\n" ${arr[0]} >> groups4/$name 
        printf "%s\n" ${arr[1]} >> groups4/$name
    fi
done < $1 
