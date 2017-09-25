sample=$1
RAW_DIR=$2
sample_OUT_DIR=$3
PICARD="/database/software/picard-1.141"

# 3 -- SortSam   #sample 158 costs 1min
echo "`date`---Sortsam start"
java -Xmx5g -jar $PICARD/picard.jar SortSam \
I=$sample_OUT_DIR/${sample}.sam \
O=$sample_OUT_DIR/${sample}.bam \
SORT_ORDER=coordinate
CREATE_INDEX=TRUE