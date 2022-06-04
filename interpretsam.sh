###### SAM header line
@RG ID:ERR003612 PL:ILLUMINA LB:g1k-sc-NA20538-TOS-1 PI:2000 DS:SRP000540 SM:NA20538 CN:SC
#Read_group #RG_identifier #seq_platform #library #fragment_Insert_size #Description #Sample #seqencing_centre

#Now use the samtools view command to print the header of the BAM file:
samtools view -H NA20538.bam | less


##### SAM header and samtools
#version of the human assembly was used to perform the alignments
#Ref_seq_dict  #Ref_seq_name #Ref_seq_length #Genome_assembly_identifier
@SQ     SN:14   LN:107349540    AS:NCBI37

#lanes are in this BAM file
samtools view -H NA20538.bam | grep '@RG' | wc -l

# Programs used to generate .bam
@PG     ID:samtools     PN:samtools     PP:GATK IndelRealigner  VN:1.10 CL:samtools view -H NA20538.bam
#Prog #prog_rec_id #prog_name #previous_prog_id #prog_version #cmdline 


#######Alignment formats conversion
#convert between SAM<->BAM and to view or extract regions of a BAM file

#SAM FILE Format headers
#QNAME #FLAG #RNAME #POS #MAPQ #CIGAR #RNEXT #PNEXT #TLEN #SEQ #QUAL 
ERR003762.900824        113     1       20000412        23      37M     4       46506371        0       TGCAGTGGTACA   1;==583:1@BBA?BB9?>ABB@A,;

# Getting the first line
samtools view NA20538.bam | head -1

#convertion of BAM file to a CRAM file
samtools view -T Saccharomyces_cerevisiae.EF4.68.dna.toplevel.fa -C -o yeast1.cram yeast.bam



#######Converting to VCF/BCF using bcftools
