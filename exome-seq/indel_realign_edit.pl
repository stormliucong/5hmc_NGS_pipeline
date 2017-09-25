#!/usr/bin/perl
use strict;

#my $REF = "/home/cong/work/somatic/ref/ucsc.hg19.fasta";
my $REF = "/workstation/work/cong/sources/ref/ucsc.hg19.fasta";

my $GATK = "/home/cong/work/somatic/GenomeAnalysisTK-3.4";
my $picard = "/home/cong/work/picard/picard-tools-1.119";
#my $mdup_bam = "/data2/Tmp/PRJEB9083/Blood_normal/mdup_bam";
#my $mdup_bam = "/workstation/work/cong/BRCA/PRJEB9083/Tissue_normal/mdup_bam";
my $GOLD_INDELS = "/workstation/work/cong/sources/gatk_bundles/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf";
#my $ind_re = "/workstation/work/cong/BRCA/PRJEB9083/Tissue_normal/indel_realign"; 

#my $mdup_bam = "/workstation/work/cong/BRCA/PRJEB9083/tumor/mdup_bam";
#my $ind_re = "/workstation/work/cong/BRCA/PRJEB9083/tumor/indel_realign";
#my $mdup_bam = "/workstation/work/cong/BRCA/PRJEB9083/normal_add/mdup_bam";
#my $ind_re = "/workstation/work/cong/BRCA/PRJEB9083/normal_add/indel_realign";
#my $mdup_bam = "/workstation/work/cong/BRCA/hilbers/Exomen_1/mdup_bam";
#my $ind_re = "/workstation/work/cong/BRCA/hilbers/Exomen_1/indel_realign";
#tophat2 mapped data
#my $mdup_bam = "/workstation/work/cong/BRCA/PRJEB9083/RNA-seq/splitN_fixed";
#my $ind_re = "/workstation/work/cong/BRCA/PRJEB9083/RNA-seq/indel_realign";

my $mdup_bam = "/workstation/work/cong/BRCA/PRJEB9083/RNA-seq/SNPiR/mdup_mapped";
my $ind_re = "/workstation/work/cong/BRCA/PRJEB9083/RNA-seq/SNPiR/indel_realign";

my $infile = $ARGV[0];
open(INPUT,"<$infile");

while(<INPUT>){
chomp;
push(my @list,$_);
foreach my $list (@list){
my $mdup = $list.".mdup.bam";
#for RNA-seq tophat2 mapped data
#my $mdup = $list.".mdup.splitN.fixed.bam";

#prepare target intervals for indel realign
my $RealignerTargetCreator = 
	"mkdir -p $ind_re && java -Xmx6g -jar $GATK/GenomeAnalysisTK.jar " .
	"-T RealignerTargetCreator " .
	"-R $REF " .
	"-I $mdup_bam/$mdup " .
	"-known $GOLD_INDELS " .
	"-o $ind_re/$list.target_intervals.list";
system($RealignerTargetCreator) == 0 or die();

#indel realign	
my $IndelRealigner = 
	"java -Xmx6g -jar $GATK/GenomeAnalysisTK.jar " .
	"-T IndelRealigner " .
	"-R $REF " .
	"-I $mdup_bam/$mdup " .
	#"-L $Bedfile " .
	"-targetIntervals $ind_re/$list.target_intervals.list " .
	"-known $GOLD_INDELS " .
	"-o $ind_re/$list.mdup.realigned.bam";
	#"-o $ind_re/$list.mdup.splitN.fixed.realigned.bam";
system($IndelRealigner) == 0 or die();

}

}

