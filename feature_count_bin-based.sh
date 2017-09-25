sample=$1
RAW_DIR=$2
sample_OUT_DIR=$3
SUBREAD="/database/software/subread-1.5/bin"

#7  --feature count bin-based
echo "`date`---FeatureCount bin-based"
# MODIFIED By CL @ 2016-09-28
# Turn on -p option to fragments (or templates) 
# instead of reads.
# This option is only applicable for paired-end reads.

$SUBREAD/featureCounts \
-p \
-T 1 \
-t bin \
-Q 10 \
-g gene_name \
-f \
-B \
-C \
--primary \
-a /database/hg19/EncodeFeature/bin.gtf \
-o $sample_OUT_DIR/${sample}.bin \
$sample_OUT_DIR/${sample}.dup.bam
echo "`date`---FeatureCount bin-based end"
