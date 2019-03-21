#!/usr/local/bin/python3
import sys
import os.path




with open(sys.argv[1]) as f:
    length_gene = int(f.readline())
    length_oligo = 75
    c = 0
    snp = {} #keys are snp positions, values are tuple with name, nuc in consensus, nuc in snp, OTHERSNP if not unique identifying SNP
    oligs = {}
    names = set()

    for line in f:
        #print(line)
        line = line.split()
        name = line[0].split("|")[4][4:]
        entry = (name,line[2], line[3])
        names.add(name)

        if int(line[1]) not in snp:
            if len(line) == 5:
                continue
            else:   
                v = [entry]
                snp[int(line[1])] = v
        else:
            if len(line) == 5:
                continue
            else:
                v = (entry)
                snp[int(line[1])].append(v)


    #print(snp)
    #print(names)
    #print("")
   
   
    for i, j in zip(range(1,length_gene-73), range(75,length_gene +1)):
    #for i, j in zip(range(1,6), range(5,11)):
    #for i, j in zip(range(1,2), range(5,6)):
        #print(i,j)
        index = str(i) +"-"+ str(j)
        #print(index)

        for x in snp.keys():
            if i+c <= x <= j-c:
                for t in range(len(snp[x])):
                    if index not in oligs:
                        oligs[index] = {}
                        oligs[index][x] = snp[x]
                    else:
                        oligs[index][x] = snp[x] 
        
    #print(oligs)
    #print("")


    for name in names:
        new_oligos = {}
        #print(name)
        for x in oligs.keys():
            #print(x)
            vals = str(oligs[x].values())
            n = vals.count(name)
            if n > 1:
                new_oligos[x] = {}
                for k,v in oligs[x].items():
                    for t in range(len(v)):
                        if v[t][0] == name:
                            new_oligos[x][k] = [v[t]]

        #print(new_oligos)

        if new_oligos != {}:
            with open('/home/brianne/sepsis2/Card/geneFamily/nucOrder/all/alignmafft/sequences/' +name) as strand:
                line = strand.readline()
                for x in new_oligos.keys():
                    new_oligos_header = str(new_oligos[x]).replace(" ","")
                     

                    start = int(x.split("-")[0])-1
                    end = int(x.split("-")[1])
                    seq = line[start:end] 
                    GC = int((seq.count("G")+seq.count("C")+seq.count("c")+seq.count("g"))/len(seq)*100)
                    end = end - 1

                    if "-" in seq:
                        continue
                    else:
                        print(">"+ name + "|" + str(start) + "-" + str(end) + "|" + new_oligos_header + "|" + "|" + str(GC))
                        print(seq)
                      



 
