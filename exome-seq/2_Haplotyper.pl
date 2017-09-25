#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: 2_Haplotyper.pl
#
#        USAGE: ./2_Haplotyper.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#      VERSION: 1.0
#      CREATED: 2015年10月11日 13时43分52秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

my $REF = "/home/cong/ref/hg19.fa"; # input your own reference fastq prefix.
my $GATK = "/home/cong/bin/GenomeAnalysisTK-3.4/"; # input your own GATK bin.
my $dbSNP = "/home/cong/ref/dbsnp/dbsnp_138.hg19.vcf"; #input your own dbsnp vcf file.
my $Bedfile = "/home/cong/ref/Exome_target_file/RefSeq.hg19.bed"; #input your exome bed.
my $OUTPUT_DIR = "/home/cong/work/my_project/HaplotyperCaller"; # output dir
my $BAM_DIR = "/home/cong/work/my_project/bam"; # input your bam dir.

# following are OPTIONS.
my $GOLD_INDELS = "/home/cong/ref/gatk_bundles/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf";
my $ind_re = "/home/cong/work/my_project/indel_realign";
my $recal = "/home/cong/work/my_project/recal";



my $infile = $ARGV[0]; # sample name file and each line is a sample name.
open(INPUT,"<$infile");

while(<INPUT>){
	chomp;
	push(my @list,$_);
	foreach my $list (@list){

		my $bam="${list}.dup.bam";

#######################################################################
# THIS PART IS OPTIONAL
#######################################################################
		#prepare target intervals for indel realign

		my $RealignerTargetCreator = 
			"mkdir -p $ind_re && java -Xmx6g -jar $GATK/GenomeAnalysisTK.jar " .
			"-T RealignerTargetCreator " .
			"-R $REF " .
			"-I $BAM_DIR/$bam " .
			"-known $GOLD_INDELS " .
			"-o $ind_re/${list}.target_intervals.list";
		system($RealignerTargetCreator) == 0 or die();

		#indel realign	
		my $IndelRealigner = 
			"java -Xmx6g -jar $GATK/GenomeAnalysisTK.jar " .
			"-T IndelRealigner " .
			"-R $REF " .
			"-I $BAM_DIR/$bam " .
			#"-L $Bedfile " .
			"-targetIntervals $ind_re/$list.target_intervals.list " .
			"-known $GOLD_INDELS " .
			"-o $ind_re/${list}.realigned.bam";
			#"-o $ind_re/$list.mdup.splitN.fixed.realigned.bam";
		system($IndelRealigner) == 0 or die();

		# Base recalibrating
		my $FirstBaseRecalibrator = 
			"java -Xmx6g -jar $GATK/GenomeAnalysisTK.jar " .
			"-T BaseRecalibrator " .
			"-R $REF " .
			"-I $ind_re/${list}.realigned.bam " .
			"-L $Bedfile " .
			"-knownSites $dbSNP " . 
			"-knownSites $GOLD_INDELS " .
			"-o $ind_re/${list}.recal_data.table ";

		system($FirstBaseRecalibrator) == 0 or die();

		my $SecondBaseRecalibrator =

			"java -Xmx6g -jar $GATK/GenomeAnalysisTK.jar " .
			"-T BaseRecalibrator " .
			"-R $REF " .
			"-I $ind_re/${list}.realigned.bam " .
			"-L $Bedfile " .
			"-knownSites $dbSNP " . 
			"-knownSites $GOLD_INDELS " .
			"-BQSR $ind_re/${list}.recal_data.table " .
			"-o $ind_re/${list}.post_recal_data.table";
		system($SecondBaseRecalibrator) == 0 or die();

#######################################################################
# END
#######################################################################
		my $HaplotypeCaller = 
				"mkdir -p $OUTPUT_DIR && java -Xmx6g " . 
				"-jar $GATK/GenomeAnalysisTK.jar " . 
				"-R $REF " .
				#"-T DepthOfCoverage " .
				"-T HaplotypeCaller " .
				"-AR $Bedfile " .
				"-I $BAM_DIR/$bam " .
				"-L $Bedfile " .
				"--dbsnp $dbSNP " .
				"-mbq 10 " .
				"-stand_call_conf 30.0 " . 
				"-stand_emit_conf 10.0 " .
				"--minPruning 3 " .
				"-bamout $OUTPUT_DIR/$list.emit10.recal  " .
				"-o /$OUTPUT_DIR/$list.emit10.haplotypecaller.vcf ";
		system($HaplotypeCaller) == 0 or die();

	}
}
close(INPUT);

