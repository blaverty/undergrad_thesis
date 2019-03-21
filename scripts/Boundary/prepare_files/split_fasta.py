#!/usr/bin/python 

from Bio import SeqIO
import string
from optparse import OptionParser
import os

#python2 split_fasta.py -f fileintput -o fileoutput
#change number of fasta in each file and name of output files in
#code before running


parser = OptionParser()
parser.add_option("-f", "--fasta_file", dest="query_handle", help="fasta file of all transcripts", metavar="FILE")
parser.add_option("-o", "--out_dir", dest="out_handle", help="out directory for all split fasta files", metavar="FILE")
(options, args) = parser.parse_args()

def batch_iterator(iterator, batch_size):
    """Returns lists of length batch_size.

    This can be used on any iterator, for example to batch up
    SeqRecord objects from Bio.SeqIO.parse(...), or to batch
    Alignment objects from Bio.AlignIO.parse(...), or simply
    lines from a file handle.

    This is a generator function, and it returns lists of the
    entries from the supplied iterator.  Each list will have
    batch_size entries, although the final list may be shorter.
    """
    entry = True  # Make sure we loop once
    while entry:
        batch = []
        while len(batch) < batch_size:
            try:
                entry = iterator.next()
            except StopIteration:
                entry = None
            if entry is None:
                # End of file
                break
            batch.append(entry)
        if batch:
            yield batch

#seqs = []
#for record in SeqIO.parse(options.query_handle, "fasta"):
#    seqs.append(record) 

seqs = SeqIO.parse(options.query_handle, 'fasta')



for i, batch in enumerate(batch_iterator(iter(seqs), 100000)):
#for i, batch in enumerate(batch_iterator(seqs, 1000)):
    filename = "oligo%i.fa" % (i+1)
    filename_full = os.path.join(options.out_handle, filename) 
    handle = open(filename_full, "w")
    count = SeqIO.write(batch, handle, "fasta")
    handle.close()
    print("Wrote %i records to %s for diamond blastx" % (count, filename))
