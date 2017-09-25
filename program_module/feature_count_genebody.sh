sample=$1
RAW_DIR=$2
sample_OUT_DIR=$3
SUBREAD="/database/software/subread-1.5/bin"

#6 --feature count genebody
# MODIFIED By CL @ 2016-09-28
# Turn on -p option to fragments (or templates) 
# instead of reads.
# This option is only applicable for paired-end reads.

echo "`date`---FeatureCount genebody start"
$SUBREAD/featureCounts \
-p \
-t genebody \
-T 1 \
-Q 10 \
-g gene_name \
-f \
-B \
-C \
--primary \
-a /database/hg19/EncodeFeature/genebody_promoter_v24_hg19.gtf \
-o $sample_OUT_DIR/${sample}.genebody \
$sample_OUT_DIR/${sample}.dup.bam
echo "`date`---FeatureCount genebody end"
