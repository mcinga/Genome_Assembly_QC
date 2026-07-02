#!/usr/bin/env nextflow
nextflow.enable.dsl=2

input_assembly = Channel.fromPath(params.input)
input_reads = Channel.fromPath(params.input_reads)
kmer_ch = Channel.value(params.kmer)
memory_ch = Channel.value(params.memory)
threads_ch = Channel.value(params.threads)


process GFASTATS {

        publishDir "${params.out}/gfastats", mode : 'copy'

        input:
        path assembly

        output:
        path 'gfastats_results.txt', emit : gfastasts_channel

        script:

        """
        gfastats ${assembly} > gfastats_results.txt

        """
}

process BUSCO {

        publishDir "${params.out}/busco", mode : 'copy'

        input :
        path assembly

        output:
        path 'busco_results', emit: busco_channel

        script :

        """
        export JAVA_TOOL_OPTIONS="-Xmx16g -Xms8g"
        export _JAVA_OPTIONS="-Xmx16g -Xms8g"

        busco -i ${assembly} -o busco_results -m genome -l primates_odb12 -f
        """

}

process MERYL {

        publishDir "${params.out}/meryl_db", mode : 'copy'

        input :
        val kmer
        val memory
        val threads
        path reads

        output:
        path 'read-db.meryl', emit: meryldb_channel

        script:

        """
        meryl count k=${kmer} memory=${memory} threads=${threads} ${reads} output read-db.meryl

        """
}

process MERQURY {

        publishDir "${params.out}/Mequry_QV", mode : 'copy'

        input:
        path meryldb
        path assembly

        output:
        path 'merqury_output*', emit: merqury_channel

        script:

        """
        merqury.sh ${meryldb} ${assembly} merqury_output
        """
}


workflow {

GFASTATS(input_assembly)
BUSCO(input_assembly)
MERYL(kmer_ch,memory_ch, threads_ch,input_reads)
MERQURY(MERYL.out.meryldb_channel,input_assembly)
}
