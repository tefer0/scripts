#!/usr/bin/env bash

# Required files SAM, BAM or CRAM format, reference_genome.fasta

# ************ 1. Making sense of the input data *************
# Check the statistics of the .bam files using the refrence genome
samtools stats -r reference_genome.fa inputfile.bam > outputfile.stats

# Can generate the GC frequency from the reference_genome.fa
# Calculate reference sequence GC for later use with -r
plot-stats -s reference_genome.fa > reference_genome.fa.gc

# Show the statistics in a graph
plot-bamstats -r reference_genome.fa.gc -p filename_dir.graphs/ inputfile.stats



# 2. ********** Generating pileup ***********************
# samtools mpileup prints the read bases that align to each position in the
# reference genome.
samtools mpileup -f reference_genome.fa inputfile.bam | less -S

#Files in the in the above outpue
#CHROMOSOME #POSITION #REF_BASE	#READ_DEPTH #READ_BASE #BASE_QUALITIES

#  For read bases ('.' or ',' indacate match on the forward or reverse)
# strand;ACGTN and acgtn a mismatch on the forward and the revese strand)
# The symbol '^' marks the beginning of a read, "$" the end of a read,
# deleted bases are represented as "*"
# (. OR ,) match on the forward or reverse
# (AAA, aaa) mismatch on the forward or reverse



# 3. ### **Generating genotype likelihoods and variant calling ************
##### Using Advanced Tools #######################
# mpileup is now in the bcftool producting a genotype likely hood
# a vcf file format view
bcftools mpileup -f GRCm38_68.19.fa A_J.bam | less -S

# intermediate output from above command can then be passed to variant caller
bcftools mpileup -f GRCm38_68.19.fa A_J.bam | bcftools call -m  | less -S

## To print out variants only
bcftools mpileup -f GRCm38_68.19.fa A_J.bam | bcftools call -mv | less -S

# We use the -Ou option to produce an uncompressed BCF
# This is to avoid the unnecessary CPU
# overhead of formatting the internal binary format into 
# plain text VCF only to be immediately formatted back to
# the internal binary format again:
bcftools mpileup -a AD -f ref_genome.fa inputfile.bam -Ou | bcftools call -mv -o outfile.vcf


#4: Variant filtering
# Most of the bcftools commands accept the -i, --include and -e, --exclude options
# filter and extract information from VCFs
# printing a simple list of positions from the VCF using the bcftools query
bcftools query -f 'POS = %POS\n' out.vcf | head

# Adding more filds from the vcf file separated by commas
bcftools query -f '%POS %REF,%ALT\n' out.vcf | head

# add also the quality, genotype and sequencing depth to the output
		  #Pos | Qual | [genotype & sequencing depth] | Ref_base | Alt_base
# For the depth, check the AD annotation (bcftools mpileup -a?)
# which gives the number of reads observed for each reference and alternate alleles
# For example, if there were 3 reads with the reference allele and 5 reads
# with the alternate allele, the AD field would be AD=3,5 .
# Note that the FORMAT fields must be enclosed within square
# brackets " [] " to iterate over all samples in the VCF

bcftools query -f'%POS %QUAL [%GT %AD] %REF %ALT\n' out.vcf | head

# Filter rows with quality smaller than 30 and exclude indels
# 10000105 104 1/1 0,14 T G  # 1/1 homozygous alternate
bcftools query -f'%POS %QUAL [%GT %AD] %REF %ALT\n' -i'QUAL>=30 && type="snp"' out.vcf | head

# Print rows with QUAL bigger than 30 and with at least 25 alternate reads?
bcftools query -f'%POS %QUAL [%GT %AD] %REF %ALT\n' -i'QUAL>=30 && type="snp" && AD>=25' out.vcf | head

#Finally, use the following command to obtain the ts/tv of unfiltered callset.
bcftools stats out.vcf | grep TSTV | cut -f5

# Filtered ts/tv
bcftools stats out.vcf -i 'QUAL>=30 && AD[0:1] >=25' | grep TSTV | cut -f5

# ts/tv of heterozyous SNP
bcftools stats -i 'GT="het"' out.vcf | grep TSTV | cut -f5

#to exclude sites with heterozygous genotypes
bcftools stats -e 'GT="het"' out.vcf | grep TSTV | cut -f5
