#!/usr/bin/perl
use strict;
use warnings;

my $GATK="/home/cong/work/somatic/GenomeAnalysisTK-3.4";
my $snpEff_jar = "/home/cong/work/snpEff/snpEff.jar";
#my $INPUT_DIR = "/workstation/work/cong/BRCA/PRJEB9083/Blood_normal/var_recal_new";
#my $INPUT_DIR = "/workstation/work/cong/BRCA/PRJEB9083/Tissue_normal/var_recal";
my $INPUT_DIR = "/workstation/work/cong/BRCA/BC/var_recal";

my $UCSC_REF="/workstation/work/cong/sources/ref/ucsc.hg19.fasta";
my $BR37_REF="/workstation/work/cong/sources/GRCH_37/human_g1k_v37.fasta";


#my $INPUT = "Tissue_normal.GenotypeGVF.dbsnp138.recal.vcf";
#my $SELECTED = "/workstation/work/cong/BRCA/PRJEB9083/Blood_normal/snpEff_ann";
#my $SELECTED = "/workstation/work/cong/BRCA/PRJEB9083/Tissue_normal/snpEff_ann";
#my $SNP = "Blood_normal.GenotypeGVF.dbsnp138.recal.snp.vcf";
#my $INDEL = "Blood_normal.GenotypeGVF.dbsnp138.recal.indel.vcf";
#my $SNP_FILTER = "Blood_normal.GenotypeGVF.dbsnp138.recal.snp.filter.vcf";
#my $INDEL_FILTER = "Blood_normal.GenotypeGVF.dbsnp138.recal.indel.filter.vcf";
#my $SNP = "Tissue_normal.GenotypeGVF.dbsnp138.recal.snp.vcf";
#my $INDEL = "Tissue_normal.GenotypeGVF.dbsnp138.recal.indel.vcf";
#my $SNP_FILTER = "Tissue_normal.GenotypeGVF.dbsnp138.recal.snp.filter.vcf";
#my $INDEL_FILTER = "Tissue_normal.GenotypeGVF.dbsnp138.recal.indel.filter.vcf";
my $INPUT = "BC-OWN.recal.vcf";
my $SNP = "BC-OWN.recal.snp.vcf";
my $INDEL = "BC-OWN.recal.indel.vcf";
my $SNP_FILTER = "BC-OWN.recal.snp.filter.vcf";
my $INDEL_FILTER = "BC-OWN.recal.indel.filter.vcf";
####select the variant
#select the SNP variants
my $select_snp = 
	"java -Xmx6g -jar $GATK/GenomeAnalysisTK.jar " .
	"-T SelectVariants " .
	"-R $UCSC_REF " .
	"-V $INPUT_DIR/$INPUT " . 
	"-o $INPUT_DIR/$SNP " .
	"-selectType SNP";
	#"-selectType MNP " .
	#"-restrictAllelesTo MULTIALLELIC"; 
system ($select_snp) == 0 or die();


my $SNP_VariantFiltration = 
	"java -Xmx5G -jar $GATK/GenomeAnalysisTK.jar " .
	"-T VariantFiltration " .
	"-R $UCSC_REF " .
	"-V $INPUT_DIR/$SNP " .
	#"--clusterWindowSize 10 " . #BC own were set out
	"-filter \"QD < 2.0 || FS > 60.0 || MQ < 40.0 || MappingQualityRankSum < -12.5 || ReadPosRankSum < -8.0\" " .
	"-filterName \"SNP_filter\" " .
	"-o $INPUT_DIR/$SNP_FILTER";
system($SNP_VariantFiltration) ==0 or die();

#select the indel variants
my $select_indel = 
	"java -Xmx6g -jar $GATK/GenomeAnalysisTK.jar " .
	"-T SelectVariants " .
	"-R $UCSC_REF " .
	"-V $INPUT_DIR/$INPUT " .
	"-o $INPUT_DIR/$INDEL " .
	"-selectType INDEL";
system ($select_indel) == 0 or die();

my $INDEL_VariantFiltration = 
	"java -Xmx5G -jar $GATK/GenomeAnalysisTK.jar " .
	"-T VariantFiltration " .
	"-R $UCSC_REF " .
	"-V $INPUT_DIR/$INDEL " .
	#"--clusterWindowSize 10 " . # BC own were set out
	"-filter \"QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0\" " .
	"-filterName \"INDEL_filter\" " .	
	"-o $INPUT_DIR/$INDEL_FILTER";
system($INDEL_VariantFiltration) ==0 or die();



