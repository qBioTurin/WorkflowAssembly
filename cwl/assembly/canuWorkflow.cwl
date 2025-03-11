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
  threads: int?
  min_coverage: int
  seq_technology: 
    - type: enum
      symbols:
        - nanopore
        - pacbio
        - pacbio-hifi

outputs: 
  contigs:
    type: File
    outputSource: medaka_canu/contigs

steps:
  canu:
    run: canu.cwl
    in:
      fastq: fastq
      genome_size: genome_size
      prefix: prefix
      threads: threads
      min_coverage: min_coverage
      seq_technology: seq_technology
    out: [contigs]
  medaka_canu:
    run: medaka.cwl
    in:
      fastq: fastq
      assembly: canu/contigs
      threads: threads
    out: [contigs] 
