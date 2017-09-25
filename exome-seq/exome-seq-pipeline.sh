path_java="/"
path_picard="/home/cong/works/software/picard-tools-1.121"
path_GATK="/home/cong/works/software/GATK"
path_NGSQCToolkit = "/home/cl/software/NGSQCToolkit_v2.3.2"
path_index="/public/mid/cong/ref"
reference="/hg19.fasta"
R1=`ls *R1.fastq`
R2=`ls *R2.fastq`


# 1.  quality control
##########################################################################
# make sure you have NGSQCToolkit installed.
##########################################################################
### quality filter ###
perl $path_NGSQCToolkit/IlluQC_PRLL.pl -pe $R1 $R2 N 1 -c 4 -o clean_data
###t rim remove short reads ###
perl $path_NGSQCToolkit/TrimmingReads.pl -i $R1 -irev $R2 -q 20 
### ambiguity filtering ###
perl $path_NGSQCToolkit/Trimming/AmbiguityFiltering.pl -i $R1 -irev $R2 -n 70

# 2.  mapping
###1.bwa比对###
bwa mem -M -R "@RG\tID:2\tSM:2PD1\tPL:Illumina\tLB:lib1\tPU:unit1" -t 60 $path_index/$fa $R1 $R2 > aligned.sam

###2.picard分类、去重###
$path_java/java -jar $path_picard/SortSam.jar INPUT=aligned.sam OUTPUT=sorted.bam SORT_ORDER=coordinate
$path_java/java -jar $path_picard/MarkDuplicates.jar INPUT=sorted.bam OUTPUT=dedup.bam METRICS_FILE=metrics.txt
$path_java/java -jar $path_picard/BuildBamIndex.jar INPUT=dedup.bam

###3.IndelRealign插入缺失位置重排列###
$path_java/java -jar $path_GATK/GenomeAnalysisTK.jar -T RealignerTargetCreator -R $path_index/$fa -I dedup.bam -known $path_index/dbsnp_138.hg19.vcf -o target_intervals.list -nt 60 
$path_java/java -jar $path_GATK/GenomeAnalysisTK.jar -T IndelRealigner -R $path_index/$fa -I dedup.bam -known $path_index/dbsnp_138.hg19.vcf -targetIntervals target_intervals.list -o realigned.bam

###4.BaseRecalibrate碱基重校准###
$path_java/java -jar $path_GATK/GenomeAnalysisTK.jar -T BaseRecalibrator -R $path_index/$fa -I realigned.bam -knownSites $path_index/dbsnp_138.hg19.vcf -o recal.table
$path_java/java -jar $path_GATK/GenomeAnalysisTK.jar -T BaseRecalibrator -R $path_index/$fa -I realigned.bam -knownSites $path_index/dbsnp_138.hg19.vcf -BQSR recal.table -o post.recal.table
$path_java/java -jar $path_GATK/GenomeAnalysisTK.jar -T AnalyzeCovariates -R $path_index/$fa -before recal.table -after post.recal.table -plots recalibration_plots.pdf
$path_java/java -jar $path_GATK/GenomeAnalysisTK.jar -T PrintReads -R $path_index/$fa -I realigned.bam -BQSR recal.table -o recal.bam


###5.Call寻找SNP###
$path_java/java -jar $path_GATK/GenomeAnalysisTK.jar -T HaplotypeCaller -R $path_index/$fa -I recal.bam --genotyping_mode DISCOVERY -stand_emit_conf 10 -stand_call_conf 30 -o variants.vcf
