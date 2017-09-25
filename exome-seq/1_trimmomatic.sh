sample=$1
RAW_DIR=$2
sample_OUT_DIR=$3
OUT_DIR=$4

TRIM="/usr/bin/Trimmomatic-0.36" # make sure change it to the directory where you install Trimmomatic.

#step1 -- Trimmomatic
echo "`date`---Trim start"
java -Xmx5g -jar $TRIM/trimmomatic-0.36.jar PE -threads 2 -phred33 /$OUT_DIR/fastq/${sample}_1.fastq.gz  /$OUT_DIR/fastq/${sample}_2.fastq.gz $sample_OUT_DIR/${sample}_1.clean.fastq.gz $sample_OUT_DIR/${sample}_1.unpaired.clean.fastq.gz $sample_OUT_DIR/${sample}_2.clean.fastq.gz $sample_OUT_DIR/${sample}_2.unpaired.clean.fastq.gz LEADING:5 TRAILING:5 SLIDINGWINDOW:5:15 MINLEN:30