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
  nanopore: boolean
  prefix: string
  threads: int?
  pacbio: boolean
  pacbio-hifi: boolean
  min_coverage: int

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
      nanopore: nanopore
      prefix: prefix
      threads: threads
      pacbio: pacbio
      pacbio-hifi: pacbio-hifi
      min_coverage: min_coverage
    out: [contigs]
  medaka_canu:
    run: medaka.cwl
    in:
      fastq: fastq
      assembly: canu/contigs
      threads: threads
    out: [contigs] 
