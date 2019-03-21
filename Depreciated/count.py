#!/usr/local/bin/python3

import sys
from itertools import groupby


#ov_hit = 0
#c_hit = 0
#min_hit = 100
#max_hit = 0
#
#ov_no = 0
#c_no = 0
#min_no = 100
#max_no = 0
#
#for line in open(sys.argv[1]):
#    line = line.split()
#    if line[0] == "hit":
#        snp = int(line[1])
#        ov_hit += 1
#        c_hit += snp
#        if int(snp) < min_hit:
#            min_hit = snp
#        if int(snp) > max_hit:
#            max_hit = snp
#
#    elif line[0] == "no":
#        snp = int(line[1])
#        ov_no += 1
#        c_no += int(line[1])
#        if int(snp) < min_no:
#            min_no = snp
#        if int(snp) > max_no:
#            max_no = snp
#
#    else:
#        num_oligos = line[0]
#
#try:
#    tot_hit = c_hit/ov_hit
#except ZeroDivisionError:
#    tot_hit = "NONE"
#
#try: 
#    tot_no = c_no/ov_no
#except ZeroDivisionError:
#    tot_no = "NONE"
#
#print(sys.argv[1])
#print("the average number of SNPs with hits is " + str(tot_hit) + ", min: " + str(min_hit) + ", max: " + str(max_hit) + ", number of oligos: " + str(num_oligos))
#print("the average number of SNPs with no hits is " + str(tot_no) + ", min: " + str(min_no) + ", max: " + str(max_no) + ", number of oligos: " + str(num_oligos))
#print("")


ishead = lambda x: x.startswith(">")

with open(sys.argv[1]) as infile:
    aro_iden = set()
    
    for key, group in groupby(infile, ishead):
        if key:
            head = (''.join(group))
 
        else:
            hits = ("").join(group).rstrip().split("\n")
            for x in hits:
                x = x.split("\t")
                query = x[0].split("|")
                name = query[4]
                aro_iden.add(name)
    
    for y in aro_iden:
        print(y)





#ishead = lambda x: x.startswith(">")
#
#oligos_work = 0
#with open(sys.argv[1]) as infile:
#    aro_clust = set()
##    c1 = 0
##    c2 = 0
##    c3 = 0
##    c4 = 0
##    c5 = 0
#    tot = 0
#    for key, group in groupby(infile, ishead):
#        if key:
#            head = (''.join(group))
#            tot += 1
# 
#        else:
#            num = 0
#            aro_oligo = set()
#            list = ('\t').join(group).split("\t")
#            for n, des in enumerate(list):
#                #print(n, des)
#                des = des.split(" ")
#                #print(des)
#                if des[1] == "hitt\n":
#                    num += 1
#                    aro_oligo.add(des[0])
#                    aro_clust.add(des[0])
#            if num > 0:
#                continue
#                #print(str(head.rstrip()))
#                #print("%s\t%s" %(str(head.rstrip()), aro_oligo))
#                #used for rep file to record ARO that oligo has snp
#                #for and hits, wc -l rep file to count number of oligos used
#    #print(aro_clust) #ARO the cluster of oligos can identify
#    print(len(aro_clust)) #how many ARO the cluster of oligos can identify
                    
                    
#            hit = list.count("hitt")
#            nohit = list.count("no")
#            divhit = list.count("divhit")
#            ranhit = list.count("ranhit")
            
#            
#            if hit > 0 and nohit == 0 and divhit == 0 and ranhit == 0:
#                c1 += 1
#            if hit > 0 and nohit > 0 and divhit == 0 and ranhit == 0:   
#                c2 +=1
#            if nohit > 0:
#                c3 += 1
#            if divhit > 0:   
#                c4 +=1
#            if ranhit > 0:              
#                c5 += 1


 
#    print(sys.argv[1])
#    print(c1/tot*100, "% of oligos hit everything they have SNPs for and no random/ divergent hits")
#    print(c2/tot*100, "% of oligos hit some things they have SNPs for and no random/ divergent hits")
#    print(c3/tot*100, "% of oligos did not hit some things they have SNPs for")
#    print(c4/tot*100, "% of oligos hit something they were >15% divergent to")
#    print(c5/tot*100, "% of oligos hit something else aka something they did not have SNPs for or were divergent to")
#    print(tot, "oligos")
#    print("")

#    with open("reporttotal", "a") as outfile:
#        if c1/tot*100 >= 75 or c2/tot*100 >= 75:
#            outfile.write(sys.argv[1]+'\n')
#            outfile.write(str(c1/tot*100))
#            outfile.write("% of oligos hit everything they have SNPs for and nothing else\n")
#            outfile.write(str(c2/tot*100))
#            outfile.write("% of oligos hit some things they have SNPs for and nothing else\n")
#            outfile.write(str(tot)+'\n\n')
#            oligos_work += tot


#would like to have high c1 or high c2
#if don't have high c1 or c2 not useful because will only pick up seq without idenifying SNPs
#c5 may not be bad because expect to hit genes in gene group that match consensus seq, but don't have any unique snps
#c5 may be bad if hitting other things (but wouldnt have identifying SNPs anyway so still ok?)
