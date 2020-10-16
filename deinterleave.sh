#!/bin/bash
# Usage: deinterleave_fastq.sh < interleaved.fastq f.fastq r.fastq 
# 
# Modified from: https://gist.github.com/nathanhaigh/3521724 

### Default values for CLI parameters
OUTPUT_DIR="."
COMPRESS_OUTPUT="FALSE"

### Parse the commandline arguments, if they are not part of the pipeline, they get sent to Snakemake
POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -i|--input)
        INPUT_FILE="$2"
        shift # Next
        shift # Next
        ;;
        -o|--output)
        OUTPUT_DIR="$2"
        shift # Next
        shift # Next
        ;;
        --output_r1)
        OUTPUT_R1="$2"
        shift # Next
        shift # Next
        ;;
        --output_r2)
        OUTPUT_R2="$2"
        shift # Next
        shift # Next
        ;;
        --compress)
        COMPRESS_OUTPUT="TRUE"
        shift # Next
        ;;
        -h|--help)
        HELP="TRUE"
        shift # Next
        ;;
        *) # Any other option
        POSITIONAL+=("$1") # save in array
        shift # Next
        ;;
    esac
done
set -- "${POSITIONAL[@]:-}" # Restores the positional arguments (i.e. without the case arguments above) which then can be called via `$@` or `$[0-9]` etc. These parameters are sent to Snakemake.

###############################################################################################################
#####            TO RUN WITHOUT NEEDING OTHER INPUT/PARAMETERS                                            #####
###############################################################################################################

### Print triumph_pipeline help message
if [[ $HELP == "TRUE" ]]; then
    line
    echo "
Usage: deinterleave.sh -i <path/to/interleaved/fastq> 

Options:
-i, --input         Interleaved fastq file. The name must have the extension '.fastq', '.fastq.gz', '.fq', or '.fq.gz'. No default.

-o, --output        Name of output directory (it will be created if it doesn't exist already). Default: current directory

--output_r1         Name of the output file (not including output directory) for the forward reads. Default: same name than input file 
                    but adding the suffix _R1 to the name. For instance if the interleaved file is 'sample1.fastq', the output_r1 file 
                    will be 'sample1_R1.fastq(.gz)'

--output_r2         Name of the output file (not including output directory) for the reverse reads. Default: same name than input file 
                    but adding the suffix _R2 to the name. For instance if the interleaved file is 'sample1.fastq', the output_r2 file 
                    will be 'sample1_R2.fastq(.gz)'

--compress          The default is not to compress the output. If you wish to compress it instead, add this flag to the command

-h|--help           Print this help

"
    line
    exit 0
fi

###############################################################################################################
#####                       CHECKERS FOR INPUT AND SET DEFAULTS                                           #####
###############################################################################################################

# Check input file 
if [ -z $INPUT_FILE ]
then
    echo "ERROR! You must provide an input file while calling this tool: \n \tdeinterleave.sh -i <path/to/interleaved/fastq>"
elif [ ! -f $INPUT_FILE ]
then
    echo "ERROR! The provided input file does not exist! Please check that the provided path to your input file is correct"
fi

# Default output files

SAMPLE_NAME=`basename ${INPUT_FILE}`
SAMPLE_NAME=${SAMPLE_NAME%.f*q*}

if [ -z $OUTPUT_R1 ]
then
    OUTPUT_R1=${SAMPLE_NAME}_R1.fastq
fi

if [ -z $OUTPUT_R2 ]
then
    OUTPUT_R2=${SAMPLE_NAME}_R2.fastq
fi

# Set up some defaults

# If the third argument is the word "compress" then we'll compress the output using pigz

mkdir -p $OUTPUT_DIR

if [[ ${INPUT_FILE} == ${INPUT_FILE%.gz} ]]
then
    cat $INPUT_FILE | \
    paste - - - - - - - - \
    | tee \
        >(cut -f 1-4 \
        | tr "\t" "\n" \
        > $OUTPUT_DIR/${OUTPUT_R1}) \
    | cut -f 5-8 \
    | tr "\t" "\n" \
    > $OUTPUT_DIR/${OUTPUT_R2}
else
    zcat $INPUT_FILE | \
    paste - - - - - - - - \
    | tee \
        >(cut -f 1-4 \
        | tr "\t" "\n" \
        > $OUTPUT_DIR/${OUTPUT_R1}) \
    | cut -f 5-8 \
    | tr "\t" "\n" \
    > $OUTPUT_DIR/${OUTPUT_R2}
fi

if [[ $COMPRESS_OUTPUT == "TRUE" ]] 
then
    gzip $OUTPUT_DIR/${OUTPUT_R1}
    gzip $OUTPUT_DIR/${OUTPUT_R2}
fi
