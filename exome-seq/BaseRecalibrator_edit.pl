#!/usr/bin/perl
use strict;
#for PRJeb9083

#my $REF = "/home/cong/work/somatic/ref/ucsc.hg19.fasta";
my $REF = "/workstation/work/cong/sources/ref/ucsc.hg19.fasta";
my $GATK = "/home/cong/work/somatic/GenomeAnalysisTK-3.4";
#my $INFOLDER="/work_extension/cong/fastq/BRCA-";


my $dbSNP="/workstation/work/cong/dbsnp/dbsnp_138.hg19.vcf";

my $GOLD_INDELS = "/home/cong/work/somatic/GATK_bundles/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf";
my $Bedfile="/home/cong/work/Exome_target_file/RefSeq.hg19.bed";
my $picard = "/home/cong/work/picard/picard-tools-1.119";



#Blood_normal
#my $ind_re = "/workstation/work/cong/BRCA/PRJEB9083/Blood_normal/indel_realign";
#my $recal ="/workstation/work/cong/BRCA/PRJEB9083/Blood_normal/recal";

#Tissue_normal
#my $ind_re = "/workstation/work/cong/BRCA/PRJEB9083/Tissue_normal/indel_realign";
#my $recal ="/workstation/work/cong/BRCA/PRJEB9083/Tissue_normal/recal";

#tumor
#my $ind_re = "/workstation/work/cong/BRCA/PRJEB9083/tumor/indel_realign";
#my $recal = "/workstation/work/cong/BRCA/PRJEB9083/tumor/recal";

#my $ind_re = "/workstation/work/cong/BRCA/PRJEB9083/normal_add/indel_realign";
#my $recal = "/workstation/work/cong/BRCA/PRJEB9083/normal_add/recal";

#my $ind_re = "/workstation/work/cong/BRCA/hilbers/Exomen_1/indel_realign";
#my $recal = "/workstation/work/cong/BRCA/hilbers/Exomen_1/recal";

#my $ind_re = "/workstation/work/cong/BRCA/PRJNA246094/indel_realign";
#my $recal = "/workstation/work/cong/BRCA/PRJNA246094/recal";
my $ind_re = "/workstation/work/cong/BRCA/BC/indel_realign";
my $recal = "/workstation/work/cong/BRCA/BC/recal";

my $infile = $ARGV[0];
open(INPUT,"<$infile");

while(<INPUT>){
chomp;
push(my @list,$_);
foreach my $list (@list){
my $tag=".mdup.realigned.bam";
my $INFILE = "$list"."$tag";


my $FirstBaseRecalibrator = 
	"java -Xmx6g -jar $GATK/GenomeAnalysisTK.jar " .
	"-T BaseRecalibrator " .
	"-R $REF " .
	"-I $ind_re/$INFILE " .
	"-L $Bedfile " .
	"-knownSites $dbSNP " . 
	"-knownSites $GOLD_INDELS " .
	"-o $ind_re/$list.recal_data.table ";

system($FirstBaseRecalibrator) == 0 or die();

my $SecondBaseRecalibrator =

	"java -Xmx6g -jar $GATK/GenomeAnalysisTK.jar " .
	"-T BaseRecalibrator " .
	"-R $REF " .
	"-I $ind_re/$INFILE " .
	"-L $Bedfile " .
	"-knownSites $dbSNP " . 
	"-knownSites $GOLD_INDELS " .
	"-BQSR $ind_re/$list.recal_data.table " .
	"-o $ind_re/$list.post_recal_data.table";
system($SecondBaseRecalibrator) == 0 or die();

=pod
#gatk AnalyzeCovariates
my $AnalyseCovariates = 
	"java -Xmx6g -jar $GATK/GenomeAnalysisTK.jar " .
	"-T AnalyzeCovariates " .
	"-R $REF " .
	"-before $INFOLDER/$SAMPLE_ID.recal_data.table " .
	"-after $INFOLDER/$SAMPLE_ID.post_recal_data.table " .
	"-plots $INFOLDER/$SAMPLE_ID.recalibration_plots.pdf";
system($AnalyseCovariates) == 0 or die();
=cut

#apply the recalibration to the sequence data with gatk PrintReads

my $PrintReads = 
	"mkdir -p $recal && java -Xmx6g -jar $GATK/GenomeAnalysisTK.jar " .
	"-T PrintReads " .
	"-R $REF " . 
	"-I $ind_re/$INFILE " .
	"-BQSR $ind_re/$list.recal_data.table " .
	"-o $recal/$list.mdup.realign.recal_reads.bam";
system ($PrintReads) == 0 or die();

}
}

