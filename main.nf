#!/usr/bin/env nextflow

process fast5Processing {    
    publishDir ".", mode: 'copy'
    input:
    output:
    val "fast5Processing" into fast5ProcessingFlag

    script:
        """
            cd /workspace/ieo4032/guppy_yeast_ime4_1_test/fast5/
            multi_to_single_fast5 --threads ${task.cpus} --input_path . --save_path .
            rm -f FA*
        """
}