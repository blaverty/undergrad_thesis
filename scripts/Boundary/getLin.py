#!/usr/bin/python2
import sys
import re

## RUN FROM INFO115

from cogent.parse.ncbi_taxonomy import NcbiTaxonomyFromFiles
tree = NcbiTaxonomyFromFiles(open('/2/scratch/brianne/taxonomy/nodes.dmp'), open('/2/scratch/brianne/taxonomy/names.dmp'))
root = tree.Root

# Here is an example of how to get the NCBI taxon IDs for all Eukaryota phylums
# euks = root.getNodeMatchingName('Eukaryota')
# for node in euks.getRankedDescendants('phylum'):
#     print node.Name, node.TaxonId
# 
# Chlorophyta 3041
# Streptophyta 35493
# Chytridiomycota 4761
# Microsporidia 6029
# Glomeromycota 214504
# Neocallimastigomycota 451455
# Blastocladiomycota 451459
# Ascomycota 4890
# 
# etc

# to get the full lineage for defined ranks based on an input Taxon id
ranks = ['superkingdom','phylum','class','order','family','genus','species']
def get_lineage(node, my_ranks):
    """returns lineage information in my_ranks order"""
    ranks_lookup = dict([(r,idx) for idx,r in enumerate(my_ranks)])
    lineage = [None] * len(my_ranks)
    curr = node
    while curr.Parent is not None:
        if curr.Rank in ranks_lookup:
            lineage[ranks_lookup[curr.Rank]] = curr.Name
        curr = curr.Parent
    return lineage

with open(sys.argv[1]) as file:
    for line in file:
        if line[0] == ">":
            print line,
        else:
            line = line.split()
            key = line[1]
            if key == "N/A":
                continue
            else:
                try:
                    node = tree.ById[int(key)] # some taxon id...
                    
                    lineage = get_lineage(node, ranks)
                    print " , ".join(line[0:2]),
                    for x in range(7):
                        print ",",
                        print lineage[x],
                    print ",",
                    print " ".join(line[2:]) 

                except ValueError:
                    key = key.split(";")[0]
                    try:
                        node = tree.ById[int(key)] # some taxon id...
                        lineage = get_lineage(node, ranks)
                        row = [line[0], key]
                        print " , ".join(row[:]),
                        for x in range(7):
                            print ",",
                            print lineage[x],
                        print ",",
                        strains = " ".join(line[2:])
                        strain = strains.split(";")[0]
                        print "".join(strain) 

                    except KeyError:
                        with open('/2/scratch/brianne/taxonomy/merged.dmp') as f:
                            p = re.compile('^' + key + '\s')
                            for x in f:
                                if p.match(x):
                                    newkey = x.split()[2]
                            node = tree.ById[int(newkey)]
            
                            lineage = get_lineage(node, ranks)
                            row = [line[0], newkey]
                            print " , ".join(row[:]),
                            for x in range(7):
                                print ",",
                                print lineage[x],
                            print ",",
                            strains = " ".join(line[2:])
                            strain = strains.split(";")[0]
                            print "".join(strain) 

                except KeyError:
                    with open('/2/scratch/brianne/taxonomy/merged.dmp') as f:
                        p = re.compile('^' + key + '\s')
                        for x in f:
                            if p.match(x):
                                newkey = x.split()[2]
                        node = tree.ById[int(newkey)]
                    #print("KeyError of " + key + " for " + line[0])
            
                        lineage = get_lineage(node, ranks)
                        row = [line[0], newkey]
                        print " , ".join(row[:]),
                        for x in range(7):
                            print ",",
                            print lineage[x],
                        print ",",
                        print " ".join(line[2:]) 
