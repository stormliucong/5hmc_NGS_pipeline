#!usr/bin/bash 

convert2annovar.pl --format vcf4old ALL_dbsnp144_hg19_chrX_snp.vcf >ALL_dbsnp144_hg19_chrX_snp.avinput
annotate_variation.pl --geneanno --outfile ALL_dbsnp144_hg19_chrX_snp  --buildver hg19 ALL_dbsnp144_hg19_chrX_snp.avinput /workstation/database/ANNOVAR/humandb/
table_annovar.pl tumor.avinput humandb/ -buildver hg19 -out name -remove -protocol refGene,cytoBand,genomicSuperDups,esp6500siv2_all,1000g2015aug_all,1000g2015aug_eur,exac03,avsnp147,dbnsfp30a -operation g,r,r,f,f,f,f,f,f -nastring . -csvout