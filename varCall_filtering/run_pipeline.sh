#!/bin/bash

### default variables
outputdir=.					# output directory
java_memory=6					# memory of the Java virtual mach in Gigabytes
patient="patient" 				# patient name
debug=0						# bool to turn on debugging

helpmessage=$( cat <<EOF
Usage:

$0 --bam [list_of_bam_files] --ref [ref]

Required Arguments:

  --bam		comma-delimited list of bam files (order should be: normal.bam, tumor.bam)
  --ref		faidx-indexed ref

Options:

  --outputdir	the output directory (default: cwd)
  --index	the index of the region (default: NULL)
  --steps	steps to run (default: BAFM)
  --patient	the patient name (default: patient)
  --memory	the memory for the Java virtual machine in gigabytes (default: 6)
  --debug	do not delete tmp intermediate files  (default: off)
  --scripts	location of scripts dir  (directory where this script resides - use this option only if qsub-ing)

Example:

$0 --bam tumor.bam --outputdir . --index 1 --ref /my/ref.fasta

Notes:

This scripts assumes that you have only one tumor bam file which is mapped to human hg19.
If this is not so, you must change the genome reference as well as the genome partition.
This scripts also assumes that Samtools, bgzip, tabix are in your PATH.
Also, this script uses hard-wired path to SnpEff.
You should change these to reflect their paths on your system.

EOF
)

# If no arguments, echo help message and quit
if [ $# == 0 ]
then
	echo "$helpmessage"
	exit;
fi

### getopts 
while [ $# -gt 0 ]
do
	if [  "$1" == "-h" -o "$1" == "-help" -o "$1" == "--help" ]; then
		shift; 
		echo "$helpmessage"
		exit;
	elif [  "$1" == "-outputdir" -o "$1" == "--outputdir" ]; then
		shift; 
		outputdir=$1; 
		shift
	elif [  "$1" == "-patient" -o "$1" == "--patient" ]; then
		shift; 
		patient=$1; 
		shift
	elif [  "$1" == "-ref" -o "$1" == "--ref" ]; then
		shift; 
		ref=$1; 
		shift
	elif [  "$1" == "-vcf" -o "$1" == "--vcf" ]; then
		shift; 
		vcf=$1; 
		shift
	elif [  "$1" == "-steps" -o "$1" == "--steps" ]; then
		shift; 
		stepstr=$1; 
		shift
	elif [  "$1" == "-memory" -o "$1" == "--memory" ]; then
		shift; 
		java_memory=$1;
		shift
	elif [  "$1" == "-debug" -o "$1" == "--debug" ]; then
		shift; 
		debug=1;
		shift 
	elif [  "$1" == "-index" -o "$1" == "--index" ]; then
		shift; 
		SGE_TASK_ID=$1; 
		shift
	elif [  "$1" == "--config_file" ]; then
		shift; 
		config=$1; 
		shift
	elif [  "$1" == "-annot_filt" -o "$1" == "--annot_filt" ]; then
		shift; 
		Annotation_Filtering=$1;
		shift
	elif [  "$1" == "-filter" -o "$1" == "--filter" ]; then
		shift; 
		filter=$1;
		shift
	elif [  "$1" == "-bam" -o "$1" == "--bam" ]; then
		shift; 
		input_bam=$1; 
		shift
	else	# if unknown argument, just shift
		shift
	fi
done

time1=$( date "+%s" )

echo "[start]"
echo "[pwd] "`pwd`
echo "[date] "`date`
echo "[index] "$SGE_TASK_ID
echo "[reference] "$ref
echo "[output_dir] "$outputdir
echo "[patient] "$patient
echo "[steps] "$stepstr
echo "[debug] "$debug
echo "[bam files] "$input_bam
echo "[config file] "$config
echo "[SGE_TASK_ID] "$SGE_TASK_ID

# sourcing other variables
source ${config}

mkdir -p ${outputdir}

### CHOOSE CHROMOSOME
case $SGE_TASK_ID in
      1) c="1:1-50000000";;
      2) c="1:50000001-100000000";;
      3) c="1:100000001-150000000";;
      4) c="1:150000001-200000000";;
      5) c="1:200000001-249250621";;
      6) c="2:1-50000000";;
      7) c="2:50000001-100000000";;
      8) c="2:100000001-150000000";;
      9) c="2:150000001-200000000";;
      10) c="2:200000001-243199373";;
      11) c="3:1-50000000";;
      12) c="3:50000001-100000000";;
      13) c="3:100000001-150000000";;
      14) c="3:150000001-198022430";;
      15) c="4:1-50000000";;
      16) c="4:50000001-100000000";;
      17) c="4:100000001-150000000";;
      18) c="4:150000001-191154276";;
      19) c="5:1-50000000";;
      20) c="5:50000001-100000000";;
      21) c="5:100000001-150000000";;
      22) c="5:150000001-180915260";;
      23) c="6:1-50000000";;
      24) c="6:50000001-100000000";;
      25) c="6:100000001-150000000";;
      26) c="6:150000001-171115067";;
      27) c="7:1-50000000";;
      28) c="7:50000001-100000000";;
      29) c="7:100000001-150000000";;
      30) c="7:150000001-159138663";;
      31) c="8:1-50000000";;
      32) c="8:50000001-100000000";;
      33) c="8:100000001-146364022";;
      34) c="9:1-50000000";;
      35) c="9:50000001-100000000";;
      36) c="9:100000001-141213431";;
      37) c="10:1-50000000";;
      38) c="10:50000001-100000000";;
      39) c="10:100000001-135534747";;
      40) c="11:1-50000000";;
      41) c="11:50000001-100000000";;
      42) c="11:100000001-135006516";;
      43) c="12:1-50000000";;
      44) c="12:50000001-100000000";;
      45) c="12:100000001-133851895";;
      46) c="13:1-50000000";;
      47) c="13:50000001-100000000";;
      48) c="13:100000001-115169878";;
      49) c="14:1-50000000";;
      50) c="14:50000001-100000000";;
      51) c="14:100000001-107349540";;
      52) c="15:1-50000000";;
      53) c="15:50000001-100000000";;
      54) c="15:100000001-102531392";;
      55) c="16:1-50000000";;
      56) c="16:50000001-90354753";;
      57) c="17:1-50000000";;
      58) c="17:50000001-81195210";;
      59) c="18:1-50000000";;
      60) c="18:50000001-78077248";;
      61) c="19:1-50000000";;
      62) c="19:50000001-59128983";;
      63) c="20:1-50000000";;
      64) c="20:50000001-63025520";;
      65) c="21:1-48129895";;
      66) c="22:1-50000000";;
      67) c="22:50000001-51304566";;
      68) c="X:1-50000000";;
      69) c="X:50000001-100000000";;
      70) c="X:100000001-150000000";;
      71) c="X:150000001-155270560";;
      72) c="Y:1-50000000";;
      73) c="Y:50000001-59373566";;
      74) c="MT:1-16569";;
#	*) c=$SGE_TASK_ID   
esac
echo "[region] "$c

# turn on debugging
set -eux

if [ $SGE_TASK_ID == 0 ]
then
	regionflag="";
else
	regionflag="-r $c";
fi

if [[ $stepstr == *B* ]]
then
	echo "[STEP1] pileup>bcftools"
	
	mkdir -p ${outputdir}/vcffiles_${SGE_TASK_ID}
	
	# For one sample only
	samtools mpileup -d 100000 -L 100000 -q 10 ${regionflag} -uf ${ref} ${input_bam} \
		| $BcfTools view -p 1.1 -bvcg - \
		| $BcfTools view - \
		> ${outputdir}/vcffiles_${SGE_TASK_ID}/raw_${SGE_TASK_ID}.vcf;

	echo "[date 2] "`date`;
fi

if [[ $stepstr == *A* ]] || [[ $stepstr == *F* ]]
then
	# Calling annotation and filtering script
	${Annotation_Filtering} --input-file ${outputdir}/vcffiles_${SGE_TASK_ID}/raw_${SGE_TASK_ID}.vcf \
		-s $stepstr --memory ${java_memory} --filter ${filter} --config_file ${config}
fi

time2=$( date "+%s" )
echo [deltat] $(( $time2 - $time1 ))
echo [End] `date`

