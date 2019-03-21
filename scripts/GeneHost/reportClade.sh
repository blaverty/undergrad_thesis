#!/bin/


strain=$(grep -c "species2" $1)
species=$(grep -c "species" $1)
genus=$(grep -c "genus" $1)
family=$(grep -c "family" $1) 
order=$(grep -c "order" $1)
class=$(grep -c "class" $1) 
phylum=$(grep -c "phylum" $1) 
superkingdom=$(grep -c "superkingdom" $1)

strPro=$(grep "species2" $1 | awk '{print $1}' | awk 'BEGIN{FS="|"}!seen[$6]++{print $6}' | awk '!seen[$0]++' | wc -l | awk '{print $1}')
specPro=$(grep "species" $1 | awk '{print $1}' | awk 'BEGIN{FS="|"}!seen[$6]++{print $6}' | awk '!seen[$0]++' | wc -l | awk '{print $1}')
genPro=$(grep "genus" $1 | awk '{print $1}' | awk 'BEGIN{FS="|"}!seen[$6]++{print $6}' | awk '!seen[$0]++' | wc -l | awk '{print $1}')
famPro=$(grep "family" $1 | awk '{print $1}' | awk 'BEGIN{FS="|"}!seen[$6]++{print $6}' | awk '!seen[$0]++' | wc -l | awk '{print $1}')
orPro=$(grep "order" $1 | awk '{print $1}' | awk 'BEGIN{FS="|"}!seen[$6]++{print $6}' | awk '!seen[$0]++' | wc -l | awk '{print $1}')
claPro=$(grep "class" $1 | awk '{print $1}' | awk 'BEGIN{FS="|"}!seen[$6]++{print $6}' | awk '!seen[$0]++' | wc -l | awk '{print $1}')
phyPro=$(grep "phylum" $1 | awk '{print $1}' | awk 'BEGIN{FS="|"}!seen[$6]++{print $6}' | awk '!seen[$0]++' | wc -l | awk '{print $1}')
supPro=$(grep "superkingdom" $1 | awk '{print $1}' | awk 'BEGIN{FS="|"}!seen[$6]++{print $6}' | awk '!seen[$0]++' | wc -l | awk '{print $1}')

lines=$(wc -l $1 | awk '{print $1}')
AMRpro=$(awk '{print $1}' $1 | awk 'BEGIN{FS="|"}!seen[$6]++{print $6}' | awk '!seen[$0]++' | wc -l | awk '{print $1}')
pro=2454

strPer=$(echo "scale=2;($strain *100/ $lines)" | bc -l)
spePer=$(echo "scale=2;($species *100/ $lines)" | bc -l)
genPer=$(echo "scale=2;($genus *100/ $lines)" | bc -l)
famPer=$(echo "scale=2;($family *100/ $lines)" | bc -l)
orPer=$(echo "scale=2;($order *100/ $lines)" | bc -l)
claPer=$(echo "scale=2;($class *100/ $lines)" | bc -l)
phyPer=$(echo "scale=2;($phylum *100/ $lines)" | bc -l)
supPer=$(echo "scale=2;($superkingdom *100/ $lines)" | bc -l)

strProPer=$(echo "scale=2;($strPro *100 / $pro)" | bc -l)
speProPer=$(echo "scale=2;($specPro *100 / $pro)" | bc -l)
genProPer=$(echo "scale=2;($genPro *100 / $pro)" | bc -l)
famProPer=$(echo "scale=2;($famPro *100 / $pro)" | bc -l)
orProPer=$(echo "scale=2;($orPro *100 / $pro)" | bc -l)
claProPer=$(echo "scale=2;($claPro *100 / $pro)" | bc -l)
phyProPer=$(echo "scale=2;($phyPro *100 / $pro)" | bc -l)
supProPer=$(echo "scale=2;($supPro *100 / $pro)" | bc -l)


strProPer2=$(echo "scale=2;($strPro *100 / $AMRpro)" | bc -l)
speProPer2=$(echo "scale=2;($specPro *100 / $AMRpro)" | bc -l)
genProPer2=$(echo "scale=2;($genPro *100 / $AMRpro)" | bc -l)
famProPer2=$(echo "scale=2;($famPro *100 / $AMRpro)" | bc -l)
orProPer2=$(echo "scale=2;($orPro *100 / $AMRpro)" | bc -l)
claProPer2=$(echo "scale=2;($claPro *100 / $AMRpro)" | bc -l)
phyProPer2=$(echo "scale=2;($phyPro *100 / $AMRpro)" | bc -l)
supProPer2=$(echo "scale=2;($supPro *100 / $AMRpro)" | bc -l)


#echo "input: 288708 oligos and 2454 AMR proteins"
#echo " "
echo "    clade     | % oligos id to clade  | % AMR proteins id to clade | % AMR proteins out of this step"
echo "  species2    |         $strPer          |           $strProPer            |           $strProPer2"
echo "   species    |         $spePer         |           $speProPer            |           $speProPer2"
echo "    genus     |         $genPer         |           $genProPer            |           $genProPer2"
echo "    family    |         $famPer         |           $famProPer            |           $famProPer2"
echo "    order     |         $orPer         |           $orProPer            |           $orProPer2"
echo "    class     |         $claPer         |           $claProPer            |           $claProPer2"
echo "    phylum    |         $phyPer         |           $phyProPer            |           $phyProPer2"
echo " superkingdom |         $supPer         |           $supProPer            |           $supProPer2"
echo "with $lines oligos we can identify $AMRpro AMR proteins"

