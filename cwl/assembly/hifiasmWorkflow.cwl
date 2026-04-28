#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  MultipleInputFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  fastq: File
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
    outputSource: medaka_hifiasm/contigs

steps:
  hifiasm:
    run: hifiasm.cwl
    in:
      fastq: fastq
      threads: threads
      nanopore:
        source: seq_technology
        valueFrom: |
         ${
          	return self === "nanopore" ? true : false;
          }
    out: [contigs]
  any2fasta:
    run: any2fasta.cwl
    in:
      convert: hifiasm/contigs
    out: [contigs]
  medaka_hifiasm:
    run: medaka.cwl
    in:
      fastq: fastq
      assembly: any2fasta/contigs
      threads: threads
    out: [contigs] 
