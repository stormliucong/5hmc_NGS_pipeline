sample=$1
RAW_DIR=$2
sample_OUT_DIR=$3
SUBREAD="/database/software/subread-1.5/bin"

#8  --feature count chr-based
# MODIFIED By CL @ 2016-09-28
# Turn on -p option to fragments (or templates) 
# instead of reads.
# This option is only applicable for paired-end reads.

echo "`date`---FeatureCount chr-based"
$SUBREAD/featureCounts \
-p \
-T 1 \
-t chr \
-Q 10 \
-g gene_name \
-f \
-B \
-C \
--primary \
-a /database/hg19/EncodeFeature/chr.gtf \
-o $sample_OUT_DIR/${sample}.chr \
$sample_OUT_DIR/${sample}.dup.bam
echo "`date`---FeatureCount chr-based end"
