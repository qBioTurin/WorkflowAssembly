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
  genome_size: string
  prefix: string
  threads: int
  seq_technology: 
    - type: enum
      symbols:
        - nanopore
        - pacbio
        - pacbio-hifi
  

outputs: 
  contigs:
    type: File
    outputSource: medaka_flye/contigs

steps:
  flye:
    run: flye.cwl
    in:
      fastq: fastq
      genome_size: genome_size
      prefix: prefix
      threads: threads
      seq_technology: seq_technology
    out: [contigs]
  medaka_flye:
    run: medaka.cwl
    in:
      fastq: fastq
      assembly: flye/contigs
      threads: threads
    out: [contigs] 
