#!/usr/local/bin/python3
import sys
import os.path






#scores
# g= multiple genes
# n= number of SNPs
# c= distance of SNPs from ends of oligos
# d= max divergence of identity from consensus seq
# m= max number of SNPs
# len_oligo = oligo length

#with open(sys.argv[1]) as fl:
#    with open('error','a') as out:
#        try:
#            length_gene = int(fl.readline())
#        except ValueError:
#            out.write(sys.argv[1])

with open(sys.argv[1]) as f:
    length_gene = int(f.readline())
    length_oligo = 75
    c = 5
    d = 0.15
    snp_thresh = length_oligo*d 
    snp = {} #keys are snp positions, values are tuple with name, nuc in consensus, nuc in snp, OTHERSNP if not unique identifying SNP
    score = []
    oligs = {}
    names = set()
    new_oligos = {}
    div = {}

    for line in f:
        #print(line)
        line = line.split()
        name = line[0].split("|")[4]
        entry = (name,line[2], line[3])
        names.add(name)

        if int(line[1]) not in snp:
            if len(line) == 5:
                v = [(name, line[2], line[3],line[4])]
                snp[int(line[1])] = v
            else:   
                v = [entry]
                snp[int(line[1])] = v
        else:
            if len(line) == 5:
                v = [(name, line[2], line[3],line[4])]
                snp[int(line[1])] = v
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

        
    for x in oligs.keys():
        bad = []
        vals = str(oligs[x].values()) 
        vs = []
        for z in names:
            n = vals.count(z)
            if n > snp_thresh:
                bad.append(z)
        #print(bad)
        
        if bad:
            div[x] = bad

        
        for k,v in oligs[x].items():
            #print(k,v)
            if x not in new_oligos:
                new_oligos[x] = {}
            else:
                pass
            for t in range(len(v)):
                if len(v[t]) == 3:
                    if v[t][0] not in bad:
                        if k not in new_oligos[x]:
                            new_oligos[x][k] = [v[t]]
                        else:
                            new_oligos[x][k].append(v[t])

        #print("")
        #print(new_oligos)




#if os.path.exists('/home/brianne/sepsis2/Card/geneFamily/nucOrder/85/consensus/'+sys.argv[1]) == True: 
#    name=sys.argv[1]
#else:
#    name=sys.argv[1].replace("-",":")
#with open('/home/brianne/sepsis2/Card/geneFamily/nuc/align/consensusfull/'+name) as consensus:

infile = sys.argv[1]#[:-2]
with open('/home/brianne/sepsis2/Card/geneFamily/nucOrder/all/alignmafft/consensusmafft/'+infile) as consensus:
    line = consensus.readline()
    for y in new_oligos.keys():
        #new_oligos_header = str(new_oligos[y])
        new_oligos_header = "%s" %str (new_oligos[y])
        try:
            div_header = str(div[y])
        except KeyError:
            div_header = "NA"
        div_header.replace(" ","")
        x = y.split("-")
        x[0] = int(x[0])-1
        x[1] = int(x[1])
        seq = line[x[0]:x[1]]
        x[1] = x[1] - 1
        GC = int((seq.count("G")+seq.count("C")+seq.count("c")+seq.count("g"))/len(seq)*100)
        if "n" in seq:
            continue
        else:
            print(">"+ sys.argv[1] + "|" + str(x[0]) + "-" + str(x[1])
                    + "|" + new_oligos_header + "|" + div_header + "|"
                    + str(GC))
            print(seq)


# must remove spaces in header after file made
# sed -i 's/ //g' file
        
    


        
   
