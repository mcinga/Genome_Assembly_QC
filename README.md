#Genome Assembly QC Pipeline
This Nextflow pipeline performs comprehensive quality assessment of de novo genome assemblies generated from long‑read sequencing data. It supports assemblies built from PacBio HiFi, Oxford Nanopore (ONT) ultra‑long reads, and Omni‑C/Hi‑C or trio‑based strategies. Although designed for human genomes, the workflow can be adapted to other species with minimal changes.Assembly quality is evaluated across three key metrics:

* Continuity, which is assessed with the latest version of gfastats, providing metrics such as N50.
* Correctness, which is evaluated using Merqury, quantifying base-level accuracy.
* Completeness, which is evaluated with BUSCO, which identifies conserved single‑copy orthologs to estimate gene‑level completeness.

##Requirements
* Nextflow
* Singularity

##Input structure
Ensure that the assemvlies are in one directory, and the reads are in one directory.

```
assemblies/
 - KRM.hap1.fasta
 - KRM.hap2.fasta
reads/
 * KRM.fastq.gz
```

##Running the pipeline
Create a bash script and the following:
```
module load nextflow
module load singularity 

nextflow run main.nf -profile slurm
```

##Notes
