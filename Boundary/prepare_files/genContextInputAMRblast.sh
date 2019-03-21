#!/bin/

awk '{print $2, $4, $5}' $1 > tmp1
awk '{print $1}' $1 > tmp2
awk 'BEGIN{FS="|"}{print $5}' tmp2 > tmp3
paste -d" " tmp1 tmp3 

rm tmp*
