#!/bin/bash

RAW_DIR=$1
OUT_DIR=$2

mkdir $OUT_DIR/fastq
bcl2fastq_outputdir=$OUT_DIR/fastq

/database/software/bcl2fastq2/usr/local/bin/bcl2fastq -R $RAW_DIR -o $bcl2fastq_outputdir

#loop for file rearrangement
while read sample
do
	cat $bcl2fastq_outputdir/${sample}*_S*_R1_*fastq.gz >$bcl2fastq_outputdir/${sample}_1.fastq.gz
	cat $bcl2fastq_outputdir/${sample}*_S*_R2_*fastq.gz >$bcl2fastq_outputdir/${sample}_2.fastq.gz
done<$OUT_DIR/sample_id.txt

##untermined
cat $bcl2fastq_outputdir/Undetermined*R1*fastq.gz >$bcl2fastq_outputdir/Undetermined_1.fastq.gz
cat $bcl2fastq_outputdir/Undetermined*R2*fastq.gz >$bcl2fastq_outputdir/Undetermined_2.fastq.gz

ls
# need a deletion of genereated files
echo "deleting the extra files"
rm -f *L00?_R?_001.fastq.gz
ls

#checksum
echo 'bcl2fastq successfully, printing md5'
md5sum $bcl2fastq_outputdir/*.fastq.gz>>$bcl2fastq_outputdir/md5sum.txt
