#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  MultipleInputFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  fastq: File
  threads: int
  genome_size: string  
  

outputs: 
  contigs:
    type: File
    outputSource: medaka_wtdbg2/contigs

steps:
  wtdbg2:
    run: wtdbg2/wtdbg2.cwl
    in:
      fastq: fastq
      threads: threads
      genome_size: genome_size
    out: [lay]
  wtpoa-cns:
    run: wtdbg2/wtpoa-cns.cwl
    in:
      lay: wtdbg2/lay
      threads: threads
    out: [fasta]
  medaka_wtdbg2:
    run: medaka.cwl
    in:
      fastq: fastq
      assembly: wtpoa-cns/fasta
      threads: threads
    out: [contigs] 
