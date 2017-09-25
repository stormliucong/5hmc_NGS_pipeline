sample=$1
RAW_DIR=$2
sample_OUT_DIR=$3
PICARD="/database/software/picard-1.141"

#4-- mark PCR duplicates
echo "`date`---MarkPCR-duplicate start"
java -Xmx5g -jar $PICARD/picard.jar MarkDuplicates \
REMOVE_DUPLICATES=TRUE \
I=$sample_OUT_DIR/${sample}.bam \
O=$sample_OUT_DIR/${sample}.dup.bam \
M=$sample_OUT_DIR/${sample}.dup_metrics.txt