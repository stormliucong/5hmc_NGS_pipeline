Script to run NGS analysis pipeline for 5hmc-seq.

The program could trigger processing NGS samples from BCL raw format to processed count data parallelly.

Please control the parameter to change

(1) Sample list you want to process (sample_list)
(2) program you want to run (program_list)
(3) Number of jobs submitted in the same time (program_running_PE150.sh)

The detailed paramters for each step and corresponding shell scripts are stored in program_module.
Ths script could be modified to process RNA-seq data and SNP calling. Using the module in RNA-seq and exome-seq.
