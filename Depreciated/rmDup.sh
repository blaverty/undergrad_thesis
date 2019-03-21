#!/bin/

# remove duplicate hits under same AMRgene

# bash rmDup.py file


awk '/>/{x="fAMR25."++i;}{print > x}' "$1"  


for x in fAMR25*;do
    awk '!seen[$3]++' $x > ./refined/$x
    rm $x
done

cd refined

cat fAMR25* > AMRother
rm fAMR25*


