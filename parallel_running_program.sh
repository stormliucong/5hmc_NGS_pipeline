#!/bin/bash

sample=$1
RAW_DIR=$2
sample_OUT_DIR=$3
OUT_DIR=$4
run_control_program_list=$5
program_module=$6

echo $run_control_program_list
for program_to_run in $run_control_program_list
do
  sh $program_module/${program_to_run}.sh ${sample} ${RAW_DIR} ${sample_OUT_DIR} ${OUT_DIR}
done

