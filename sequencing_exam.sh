##sequencing exam

##directories
mkdir -p data /data/raw_data docs results scritps #no error if existing, make parent directories as needed
 
##qc

fastqc *.fastq ./data/

#for sample in $(ls ./data/*fastq | cut -d _ -f 1);
#do
#R1=${sample}_1.fastq
#R2=${sample}_2.fastq
#fastq R1 R2 -o ./results
#done

##trimming
#with sickle-trim

sickle pe -f s_7_1.fastq -r s_7_2.fastq -t sanger -o s_7_1-trimmed.fastq -p s_7_2-trimmed.fastq -s s_7_12-trimmed.fastq -q 20
#pe paired end, -f forward -r reverse -t sanger tech -o out forward -p out reverse -s combined -q quality -l minlength

#with trimmomatic
trimmomatic PE SRR957824_1.fastq SRR957824_2.fastq SRR957824_1_paired.fq.gz SRR957824_1_unpaired.fq.gz SRR957824_2_paired.fq.gz SRR957824_2_unpaired.fq.gz ILLUMINACLIP:TruSeq3-SE:2:30:10 LEADING:15 TRAILING:15 SLIDINGWINDOW:4:20 MINLEN:100

#Remove adapters (ILLUMINACLIP:TruSeq3-PE.fa:2:30:10)
#Remove leading low quality or N bases (below quality 15) (LEADING:15)
#Remove trailing low quality or N bases (below quality 15) (TRAILING:15)
#Scan the read with a 4-base wide sliding window, cutting when the average quality per base drops below 20 (SLIDINGWINDOW:4:20)
#Drop reads below the 36 bases long (MINLEN:100)


##alignment

bwa-mem2 index [-p prefix] <in.fasta>

bwa-mem2 mem [options] <idxbase> <in1.fq> <in2.fq> > out.sam

samtools view -O BAM -o md5638.bam md5638.sam #sam to bam

samtools sort -T temp -O bam -o md5638.sorted.bam md5638.bam #sort bam file

bwa-mem2 mem [options] <idxbase> <in1.fq> <in2.fq> | samtools view -O BAM - | samtools sort -T temp -O bam -o md5638.sorted.bam -

#bwa mem ../../ref/GRCm38.68.dna.toplevel.chr7.fa.gz md5638a_7_87000000_R1.fastq.gz md5638a_7_87000000_R2.fastq.gz | samtools view -O BAM - | samtools sort -T temp -O bam -o md5638_2.sorted.bam -

samtools index md5638.sorted.bam #index bam

picard MarkDuplicates I=md5638.sorted.bam O=md5638.markdup.bam M=md5638.metrics.txt #0=output.bam M=outmetrics

samtools index md5638.markdup.bam #index new bam file

samtools stats md5638.markdup.bam > md5638.markdup.stats #generate qc stats

plot-bamstats -p md5638_plot/ md5638.markdup.stats #plot stats


#or
#bwa index ../../../../ref/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz
#bwa mem -M -R '@RG\tID:lane1\tSM:60A_Sc_DBVPG6044' ../../../../ref/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz s_7_1.fastq.gz s_7_2.fastq.gz | samtools view -bS - | samtools sort -T temp -O bam -o lane1.sorted.bam -
#samtools index lane1.sorted.bam
#samtools stats lane1.sorted.bam > lane1.stats.txt
#plot-bamstats -p plot/ lane1.stats.txt


#or
#bwa index reference.fa
#bwa mem reference.fa MD001_R1.fastq.gz MD001_R2.fastq.gz >MD001_aln.sam
#samtools view -O BAM -o MD001_aln.bam MD001_aln.sam
#samtools sort -T temp -O bam -o MD001_aln_sorted.bam MD001_aln.bam
#samtools index MD001_aln_sorted.bam
#picard MarkDuplicates I=MD001_aln_sorted.bam O=MD001_aln_markdup.bam M=metrics.txt
#grep -A 2 “^##METRICS” metrics.txt #to check how many reads were marked as duplicates
#samtools index MD001_aln_markdup.bam
#samtools stats MD001_aln_markdup.bam >MD001_bamstats.txt
#grep “^SN” MD001_bamstats.txt > MD001stats.txt

##variant calling
samtools mpileup -t DP -Bug -m 4 -f reference.fa MD001_aln_markdup.bam > MD001_variants.bcf #Extract all the variants from the alignment file "MD001_aln_markdup.bam"

bcftools call -mv -O v -o MD001_variants.vcf MD001_variants.bcf #bcftools call -mv -O v -o MD001_variants.vcf MD001_variants.bcf

##Filtering the variants
bcftools filter -i 'type="snp"' -g10 -G10 MD001_variants.vcf -o MD001_SNPs.vcf  #Filter only SNPs from the "MD001_variants.vcf" file

bcftools filter -i 'type="snp" && QUAL>=50 && FORMAT/DP>5 && MQ>=30' -g10 -G10 MD001_variants.vcf -o MD001_SNPs_filtered_try1.vcf #Filter the SNPs with base quality (QUAL) >=50, MQ >=30 and read depth (DP) >5

bcftools filter -i 'type="snp" && QUAL>=50 && FORMAT/DP>5 && MQ>=30 &&
DP4[2]/(DP4[2]+DP4[0])>=0.80 && DP4[3]/(DP4[3]+DP4[1])>=0.80' -g10 -G10
MD001_variants.vcf -o MD001_SNPs_filtered.vcf #Filter all homozygous SNPs (alternate base ratio >= 0.80)

#ID: SRR/ERR number
#PL: Sequencing platform
#PU: Run name
#LB: Library name
#PI: Insert fragment size
#SM: Individual/Sample
#CN: Sequencing centre

