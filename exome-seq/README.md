Human Exome-seq Analysis Pipeline
Preparation Before Start
•	Please install the following software
1.	Trimmomatic：
Bolger A M, Lohse M, Usadel B. Trimmomatic: a flexible trimmer for Illumina sequence data[J]. Bioinformatics, 2014: btu170.
 http://software.broadinstitute.org/cancer/software/genepattern/modules/docs/Trimmomatic/
	
2.	BWA：
Li H and Durbin R (2009) Fast and accurate short read alignment with Burrows-Wheeler Transform. Bioinformatics, 25:1754-60
http://bio-bwa.sourceforge.net/

3.	Picard：
Currently there is no Picard paper. You can cite Picard by referring to the website, http://broadinstitute.github.io/picard

4.	SAMTools：
Li H, Handsaker B, Wysoker A, et al. The sequence alignment/map format and SAMtools[J]. Bioinformatics, 2009, 25(16): 2078-2079.
http://samtools.sourceforge.net/

5.	GATK：
McKenna A, Hanna M, Banks E, Sivachenko A, Cibulskis K, Kernytsky A, Garimella K, Altshuler D, Gabriel S, Daly M and DePristo MA (2010) The Genome Analysis Toolkit: a MapReduce framework for analyzing next-generation DNA sequencing data. Genome Research, 20:1297-303
https://software.broadinstitute.org/gatk/

6.	ANNOVAR
Wang K, Li M, Hakonarson H. ANNOVAR: functional annotation of genetic variants from high-throughput sequencing data[J]. Nucleic acids research, 2010, 38(16): e164-e164.
http://annovar.openbioinformatics.org/en/latest/

7.	twoBitToFa 
A UCSC developed utility program, twoBitToFa (available from our src tree), can be used to extract .fa file(s) from 2bit file
http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/

•	Please prepare the following dataset
1.	hg19.2bit  hg19.fa hg19.*：
a.	download hg19.2bit from http://hgdownload.cse.ucsc.edu/goldenPath/hg19/bigZips/ 
b.	use twoBitToFa to extract hg19.fa from hg19.2bit
c.	build reference index using 
bwa index -a bwtsw hg19.fa
samtools faidx hg19.fa
java -jar picard.jar CreateSequenceDictionary \
    REFERENCE=reference.fa \ 
    OUTPUT=reference.dict

2.	Exome-bed
A bed file contains all exome regions. Could be downloaded from UCSC or obtained from your exome-seq provider.

3.	GATK bundles.
GATK bundles included SNP\Indel references you might need in SNP calling. Please refer to 
https://software.broadinstitute.org/gatk/download/bundle for details.

4.	Annotation databases.
Please refer to http://annovar.openbioinformatics.org/en/latest/ for details.
Pipeline details

Make sure you need all codes and comments. Modify corresponding directory and file name format. Otherwise, the program won’t work.
1.	Run 1_bwa_align.pl
2.	Run 2_Haplotyper.pl
3.	Run 3_annotation.sh
