# Deinterleave script

## Start the analysis. Basics

Once you have the pipeline downloaded and placed in the right partition, you can start the analysis. 

1. Open the terminal.  
2. Enter the folder of the pipeline  

```{bash}
cd /path/to/<my_folder>/deinterleave
```

3. Run the deinterleave script  

```{bash}
bash deinterleave.sh -i /path/to/<my_folder>/<my_interleaved_file>.fastq.gz
```

## Output 

Your two deinterleaved files will be located in the current directory (you can check your current directory by running the command `pwd`) and they will have the same name than the original file, but with the suffix "\_R1" for the forward reads and "\_R2" for the reverse reads. For example:

- Original file: sampleX.fastq
- Deinterleaved files:
    + Forward: sampleX_R1.fastq
    + Reverse: sampleX_R2.fastq

## Advanced use

_Different output folder_

There are other commands that might be handy to use. For instance, if you want that the result is saved in a different folder you can do this:

```{bash}
bash deinterleave.sh -i /path/to/<my_folder>/<my_interleaved_file>.fastq.gz -o /path/to/my_results
```

If the "my results" folder does not exist, it will  be created and your resulting deinterleaved files will be stored there.

_Choose name of deinterleaved files_

You can also use the names you want for the output files. For that you can do:

```{bash}
bash deinterleave.sh -i /path/to/<my_folder>/<my_interleaved_file>.fastq.gz --output_r1 my_deinterleaved_file_R1.fastq --output_r2 my_deinterleaved_file_R2.fastq
```

Note that I did not use paths there. Your output directory should be set with the option `-o`

_Compress output_ 

You may want to have the deinterleaved files compressed. Note that the compression might take a bit long. For that you can do:

```{bash}
bash deinterleave.sh -i /path/to/<my_folder>/<my_interleaved_file>.fastq.gz --compress
```

That will make sure that your two interleaved files are gzipped (and have the extension .fastq.gz).

_Combine options_

It is possible to combine more than one of this options. For example:

```{bash}
bash deinterleave.sh -i /path/to/<my_folder>/<my_interleaved_file>.fastq.gz -o /path/to/my_results --compress
```
