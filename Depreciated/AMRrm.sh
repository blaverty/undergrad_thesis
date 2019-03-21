#!/bin/

# pwd is good
# bash ../AMRrm.sh

#mkdir uncul

#for x in $(grep -liP 'vector|artificial|clone|Cloned' *.AMRgb);do
#    mv $x ../uncul2
#done
#
#cd ../uncul2
#
#for x in *;do
#    awk 'NR==1{print $2}' $x >> ../AMRUnculAcc2
#done
#

shopt -s lastpipe
while read -r line;do
    echo $line | if grep -iqP 'vector|artificial|clone|cloned|cloning|synthetic';then
        let i++
    else
        echo $line >> new
    fi
done <$1
echo $i
shopt -u lastpipe
