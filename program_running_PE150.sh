#fasq_dir
#make sure you input your own dir.
#make sure you have a sample_list.txt in your dir, which contains all sample names.
RAW_DIR="/home/liuc/work_for_novogene/NHHW161140/NHHW161140.data/fastq"
#output_dir
#make sure you input your own dir.
OUT_DIR="/home/liuc/work_for_novogene/output/NHHW161140"
#program_module
#make sure you input your own dir.
bcl2feature_all_program="/home/liuc/work_for_novogene/run_all_program_for_novogene"
#program_list
run_control_program_list=`cat $bcl2feature_all_program/program_list`
#PE150 module
program_module=$bcl2feature_all_program/program_module_PE150

#fastq2feature count
while read sample
do
	cd $OUT_DIR
	if [ -d ${sample} ]
	then 
		echo "${sample} already exists!"
		continue
	fi
	mkdir ${sample}
	sample_OUT_DIR=$OUT_DIR/${sample}
	cd $sample_OUT_DIR

sh $bcl2feature_all_program/parallel_running_program.sh ${sample} ${RAW_DIR} ${sample_OUT_DIR} ${OUT_DIR} "$run_control_program_list" ${program_module}>>$sample_OUT_DIR/${sample}.fq2bam.log 2>&1 &

#control the maximum number of samples by controling the number of 'parallel_running_program.sh'
	n=`ps -ef|grep 'parallel_running_program.sh' | wc -l`
    	while [ $n -gt 10 ]
	# Here we only allow 10 samples processed in the same time.
	# Modify this number according to the current server condition.
      	do
        	sleep 60
         	n=`ps -ef|grep 'parallel_running_program.sh' | wc -l`
      	done
done <sample_list.txt

