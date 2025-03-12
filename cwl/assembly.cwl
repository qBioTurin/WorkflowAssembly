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
  threads: int
  min_coverage: int
  seq_technology: 
    - type: enum
      symbols:
        - nanopore
        - pacbio
        - pacbio-hifi

outputs: 
  medaka_canu_out:
    type: File
    outputSource: canu/contigs
  medaka_flye_out:
    type: File
    outputSource: flye/contigs
  medaka_wtdbg2_out:
    type: File
    outputSource: wtdbg2/contigs
  quickmerge_canuflye_out:
    type: File
    outputSource: quickmerge_canuflye/contigs
  quickmerge_canuwtdbg2_out:
    type: File
    outputSource: quickmerge_canuwtdbg2/contigs
  quickmerge_flyewtdbg2_out:
    type: File
    outputSource: quickmerge_flyewtdbg2/contigs

steps:
  canu:
    run: assembly/canuWorkflow.cwl
    in:
      fastq: fastq
      genome_size: genome_size
      threads: threads
      min_coverage: min_coverage
      seq_technology: seq_technology
    out: [contigs]
  flye:
    run: assembly/flyeWorkflow.cwl
    in:
      fastq: fastq
      genome_size: genome_size
      seq_technology: seq_technology
      threads: threads
    out: [contigs]
  wtdbg2:
    run: assembly/wtdbg2Workflow.cwl
    in:
      fastq: fastq
      threads: threads
      genome_size: genome_size
    out: [contigs]
  quickmerge_canuflye:
    run: assembly/quickmerge.cwl
    in:
      hybrid: canu/contigs
      self_fasta: flye/contigs
    out: [contigs]
  quickmerge_canuwtdbg2:
    run: assembly/quickmerge.cwl
    in:
      hybrid: canu/contigs
      self_fasta: wtdbg2/contigs
    out: [contigs]
  quickmerge_flyewtdbg2:
    run: assembly/quickmerge.cwl
    in:
      hybrid: wtdbg2/contigs
      self_fasta: flye/contigs
    out: [contigs]
