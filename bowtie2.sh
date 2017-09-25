sample=$1
RAW_DIR=$2
sample_OUT_DIR=$3

# 2 -- bowtie2
echo "`date`---bowtie start"
/usr/bin/bowtie2 -q --phred33 --sensitive --end-to-end -I 0 -X 500 --fr -p 2 \
-x /database/hg19/Bowtie2Index/human_hg19 \
--n-ceil L,0.5,0.01 \
--score-min L,-1.75,-0.25 \
-1 $sample_OUT_DIR/${sample}_1.clean.fastq.gz -2 $sample_OUT_DIR/${sample}_2.clean.fastq.gz -S $sample_OUT_DIR/${sample}.sam
