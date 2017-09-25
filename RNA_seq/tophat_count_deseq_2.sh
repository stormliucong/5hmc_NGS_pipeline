#===================================================================
#    File Name: RNA-seq workflow
#       Author: XING
# Created Time: 15 Sep 2016
#===================================================================
#!/bin/bash

fastq=/home/inspur/RNA-seq/fastq
work=/home/inspur/RNA-seq
Bowtie2Index=/database/hg19/Bowtie2Index/human_hg19
trans=/database/hg19/Gencode/transcriptome_index/known
TRIM=/usr/bin/Trimmomatic-0.36
genome=/database/hg19/human.fa
tophat_dir=/database/software/TopHat/tophat-2.1.1.Linux_x86_64
cufflinks_dir=/database/software/Cufflinks/cufflinks-2.2.1.Linux_x86_64
SUBREAD="/database/software/subread-1.5/bin"
PICARD="/database/software/picard-1.141"
while read file
do
    #trimmatic for RNA-seq
    java -Xmx5g -jar $TRIM/trimmomatic-0.36.jar PE -threads 2 -phred33 $fastq/${file}_1.fastq.gz  $fastq/${file}_2.fastq.gz $work/${file}_1.clean.fastq.gz $work/${file}_1.unpaired.clean.fastq.gz $work/${file}_2.clean.fastq.gz $work/${file}_2.unpaired.clean.fastq.gz LEADING:5 TRAILING:5 SLIDINGWINDOW:5:15 MINLEN:30
    
    #tophat2
    mkdir -p ${work}/tophat/${file}
    $tophat_dir/tophat2 -p 8 -N 1 -o ${work}/tophat/${file}/ --no-coverage-search -G /database/hg19/Gencode/hg19_genes.gtf --transcriptome-index=${trans} $Bowtie2Index $work/${file}_1.clean.fastq.gz $work/${file}_2.clean.fastq.gz

# 3 -- SortSam   #sample 158 costs 1min
echo "`date`---Sortsam start"
java -Xmx5g -jar $PICARD/picard.jar SortSam \
I=${work}/tophat/${file}/accepted_hits.bam \
O=${work}/tophat/${file}/accepted_hits_sort.bam \
SORT_ORDER=coordinate
CREATE_INDEX=TRUE
done<sample_list
!    
#featureCount
    mkdir -p ${work}/count
    $SUBREAD/featureCounts \
     -p \
     -t exon \
     -T 1 \
     -Q 10 \
     -g gene_name \
     -f \
     -B \
     -C \
     --primary \
     -a /database/hg19/Gencode/hg19_genes.gtf \
     -o  ${work}/count/RNA-seq_gene_count_matrix
     ${work}/tophat/*/accepted_hits_sort.bam
     echo "`date`---FeatureCount genebody end"
#DESeq








 
