#!/usr/bin/env nextflow

process fast5Processing {    
    publishDir ".", mode: 'copy'
    input:
    output:
    val "fast5Processing" into fast5ProcessingFlag

    script:
    if(params.fast5Processing=='true')
    """
        cd /workspace/ieo4032/guppy_yeast_ime4_1/fast5/
        multi_to_single_fast5 --threads ${task.cpus} --input_path . --save_path .
        rm -f FA*
    """
    else
    """
        echo "Skipped"
    """
}

process tombo {    
    publishDir ".", mode: 'copy'

    input:
    val fast5ProcessingFlag from fast5ProcessingFlag
    
    output:
    val "tombo" into tomboFlag

    script:
    if(params.tombo=='true')
    """
        cd /workspace/ieo4032/guppy_yeast_ime4_1/fast5/
        # for d in */ ; do
        #    cd \$d
        #    ls *.fast5 | parallel -j ${task.cpus} mv {} ../
        #    cd ../
        #    rm -r \$d
        # done
        tombo resquiggle . /workspace/ieo4032/yeastReferences/yeast_ref.fa --basecall-group Basecall_1D_001 --overwrite --processes ${task.cpus} --fit-global-scale --include-event-stdev --failed-reads-filename "failedReads.txt"
    """
    else
    """
        echo "Skipped"
    """
}

process nanom6A {    
    publishDir ".", mode: 'copy'

    input:
    val fast5ProcessingFlag from fast5ProcessingFlag
    val tomboFlag from tomboFlag

    output:

    script:
    if(params.nanom6A=='true')
    """
        export PATH=/workspace/ieo4032/nanom6A_2021_3_18/bin:$PATH
        cd /workspace/ieo4032/
        data=/workspace/ieo4032/guppy_yeast_ime4_1/fast5
        find \$data -name "*.fast5"  >files.txt
        extract_raw_and_feature_fast --cpu=${task.cpus} --fl=files.txt -o result --clip=10
        predict_sites --cpu 20 -i result -o result_final -r /workspace/ieo4032/yeastReferences/yeast_transcriptome.bed -g /workspace/ieo4032/yeastReferences/yeast_genome.fa --support 0
    """
    else
    """
        echo "Skipped"
    """
}

