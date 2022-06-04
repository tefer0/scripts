#!/usr/bin/python

def has_stop_codon(dna) :
	"This checks for  stop codon in frame"
	stop_codon_found=False
	stop_codons=['tga','tag','taa']
	for i in range(0,len(dna),3) :
		codon=dna[i:i+3].lower()
		if codon in stop_codons :
			stop_codon_found=True
			break
	return stop_codon_found
