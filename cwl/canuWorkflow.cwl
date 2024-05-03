#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  MultipleInputFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  fastq: File[]
  genome_size: string
  nanopore: boolean
  prefix: string
  threads: int?
  
  

outputs: 
  contigs:
    type: File[]
    outputSource: medaka_canu/contigs

steps:
  canu:
    run: canu.cwl
    scatter: [fastq]
    in:
      fastq: fastq
      genome_size: genome_size
      nanopore: nanopore
      prefix: prefix
      threads: threads
    out: [contigs]
  medaka_canu:
    run: medaka.cwl
    scatter: [fastq, assembly]
    scatterMethod: dotproduct
    in:
      fastq: fastq
      assembly: canu/contigs
      threads: threads
    out: [contigs] 
