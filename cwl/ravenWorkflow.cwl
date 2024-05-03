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
  prefix: string
  threads: int
  
  

outputs: 
  contigs_raven:
    type: File[]
    outputSource: raven/contigs
  contigs_medaka:
    type: File[]
    outputSource: medaka_raven/contigs

steps:
  raven:
    run: raven.cwl
    scatter: [fastq]
    in:
      fastq: fastq
      prefix: prefix
      threads: threads
    out: [contigs]
  medaka_raven:
    run: medaka.cwl
    scatter: [fastq, assembly]
    scatterMethod: dotproduct
    in:
      fastq: fastq
      assembly: raven/contigs
      threads: threads
    out: [contigs] 
