#!/usr/bin/perl 
#===============================================================================
#
#         FILE: 1_bwa_align.pl
#
#        USAGE: ./1_bwa_align.pl  sample_name.txt
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#      VERSION: 1.0
#      CREATED: 2015年05月15日 10时13分20秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
my $ref = "/home/cong/ref/hg19.fa"; # input your own reference fastq prefix.
my $picard = "/home/cong/bin/picard/picard-tools-1.119";# input your own picard dir.
my $bwa = '/home/cong/bin/bwa'; # input your own bwa dir.
my $trim = '/home/cong/bin/Trimmomatic-0.36'; # input your own trim.
#my $sra_dir = "/data2/Tmp/PRJEB9083/tumor";
#my $sra_dir = "/data2/Tmp/PRJEB9083/normal";
my $work_dir = "/home/cong/work/my_project"; # input your own work dir.
my $fastq_dir = "$work_dir/fastq"; # make a fastq_dir and move all your fastq file into this dir.
my $sam_dir = "$work_dir/sam";
my $bam_dir = "$work_dir/bam";

my $inputfile = $ARGV[0]; # sample name file and each line is a sample name.
open(INPUT,"<$inputfile") or die "$!";

while(<INPUT>){
	chomp;
	#my @list = "";
	push(my @list,$_);
	system"mkdir -p $sam_dir";
	system"mkdir -p $bam_dir";

	foreach my $list (@list){

		# make sure your fq should be in a correct format.
		my $fq1 = $list."_1.fastq.gz"; 
		my $fq2 = $list."_2.fastq.gz"; 

		# maker sure modify the parameters according to your own need.
		my $TRIM = 
			"java -Xmx5g -jar $trim/trimmomatic-0.36.jar " .
			"PE -threads 2 -phred33 " .
			"$fastq_dir/${list}_1.fastq.gz " .
			"$fastq_dir/${list}_2.fastq.gz " .
			"$fastq_dir/${list}_1.clean.fastq.gz " .
			"$fastq_dir/${list}_1.unpaired.clean.fastq.gz " .
			"$fastq_dir/${list}_2.clean.fastq.gz " .
			"$fastq_dir/${list}_2.unpaired.clean.fastq.gz " .
			"LEADING:5 TRAILING:5 SLIDINGWINDOW:5:15 MINLEN:30";

		system($TRIM) == 0 or die();

		# make sure your fq should be in a correct format.
		$fq1 = $list."_1.clean.fastq.gz"; 
		$fq2 = $list."_2.clean.fastq.gz"; 
		#mapping the fastq file against reference
		my $rgstrings = "\"\@RG\tID:$list\tLB:$list\tPL:ILLUMINA\tSM:$list-bwa-mem\"";

		my $BWA_mem = 
			"$bwa/bwa mem -R $rgstrings " .
			"-M " .
			"-t 4 " .
			"$ref $fastq_dir/$fq1 $fastq_dir/$fq2 > $sam_dir/$list.sam " .
			"2>$sam_dir/$list.err";
		system($BWA_mem) == 0 or die();

		#system"bwa mem -R $rgstrings -M -t -3 $ref $fastq_dir/$fq1 $fastq_dir/$fq2 > $sam_dir/$list.sam 2>$list.err";

		#sort and cleanup
		my $SORT_CLEAN = 
			"java -Xmx6g -jar $picard/SortSam.jar " .
			"I=$sam_dir/${list}.sam " .
			"O=$bam_dir/${list}.bam " .
			"SO=coordinate " .
			"VALIDATION_STRINGENCY=LENIENT && rm $sam_dir/${list}.sam";

		system($SORT_CLEAN) == 0 or die();

		#get basic stats from the bam file
		#system"samtools flagstat $bam_dir/$list.bam > $bam_dir/$list.flagstat.txt";

		# Mark and remove PCR duplicate.
		my $MARKDUP = 
			"java -Xmx6g -jar $picard/MarkDuplicates.jar " .
			"REMOVE_DUPLICATES=TRUE " .
			"I=$bam_dir/${list}.bam " .
			"O=$bam_dir/${list}.dup.bam " .
			"M=$bam_dir/${list}.dup_metrics.txt";

		# Build Index.
		my $BUILD = 
			"java -Xmx6g -jar $picard/BuildBamIndex " .
			"I=$bam_dir/${list}.dup.bam ";
		    
		system($BUILD) == 0 or die();

		
	}	


}
close(INPUT);


