#!/usr/bin/perl
use strict;
use warnings;

my $REF = "/workstation/work/cong/sources/ref/ucsc.hg19.fasta";
my $GATK = "/home/cong/work/somatic/GenomeAnalysisTK-3.4";
my $dbsnp = "/workstation/work/cong/dbsnp/dbsnp_138.hg19.vcf";


#blood normal samples
#my $INFOLDER = "/workstation/work/cong/BRCA/PRJEB9083/Blood_normal/haplotype";
#my $COMBINE = "/workstation/work/cong/BRCA/PRJEB9083/Blood_normal/genotype";
#my $vcf_list = "/workstation/work/cong/BRCA/PRJEB9083/Blood_normal/haplotype/vcf.list";



#tissue normal sample
#my $INFOLDER = "/workstation/work/cong/BRCA/PRJEB9083/Tissue_normal/haplotype";
#my $COMBINE = "/workstation/work/cong/BRCA/PRJEB9083/Tissue_normal/genotype";
#my $vcf_list = "/workstation/work/cong/BRCA/PRJEB9083/Tissue_normal/haplotype/vcf.list";

#normal add sample


#all variant both normal and tumor
#my $INFOLDER = "/workstation/work/cong/BRCA/PRJEB9083/haplotype_all";
#my $COMBINE = "/workstation/work/cong/BRCA/PRJEB9083/haplotype_all/genotype";
#my $vcf_list = "/workstation/work/cong/BRCA/PRJEB9083/haplotype_all/all.vcf.list";

#all bc family based variants

my $INFOLDER = "/workstation/work/cong/BRCA/BRCA-/haplotype";
my $COMBINE = "/workstation/work/cong/BRCA/BRCA-/all_familial";
my $vcf_list = "/workstation/work/cong/BRCA/BRCA-/haplotype/new.vcf.list";

#genotype variant
my $genotype = 
	"mkdir -p $COMBINE && java -Xmx6g -jar $GATK/GenomeAnalysisTK.jar " .
	"-T GenotypeGVCFs " .
	"-R $REF " .
	"-V $vcf_list " .
	"--dbsnp $dbsnp " .
	"-stand_emit_conf 30.0 " . #default value is 30.0
	"-stand_call_conf 30.0 " . #default value is 30.0
	"-o $COMBINE/BRCA-.dbsnp138.g.combine.emit30.vcf"; 
	#"-o $COMBINE/BRCA-.dbsnp132.g.combine.emit30.vcf";
system ($genotype) == 0 or die();

