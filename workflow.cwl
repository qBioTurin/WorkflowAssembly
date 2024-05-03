#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  MultipleInputFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  fastq_directory: Directory
  genome_size: string
  nanopore: boolean
  prefix: string
  threads: int

outputs: 
  medaka_canu_out:
    type: File[]
    outputSource: canu/contigs
  medaka_flye_out:
    type: File[]
    outputSource: flye/contigs
  medaka_wtdbg2_out:
    type: File[]
    outputSource: wtdbg2/contigs
  quickmerge_canuflye_out:
    type: File[]
    outputSource: quickmerge_canuflye/contigs
  quickmerge_canuwtdbg2_out:
    type: File[]
    outputSource: quickmerge_canuwtdbg2/contigs
  quickmerge_flyewtdbg2_out:
    type: File[]
    outputSource: quickmerge_flyewtdbg2/contigs
    

steps:
  zerothstep:
    run: cwl/zerothStepSingleEnd.cwl
    in:
      dir: fastq_directory
    out: [reads]
  canu:
    run: cwl/canuWorkflow.cwl
    in:
      fastq: zerothstep/reads
      genome_size: genome_size
      nanopore: nanopore
      prefix: prefix
      threads: threads
    out: [contigs]
  flye:
    run: cwl/flyeWorkflow.cwl
    in:
      fastq: zerothstep/reads
      genome_size: genome_size
      nanopore: nanopore
      prefix: prefix
      threads: threads
    out: [contigs]
  wtdbg2:
    run: cwl/wtdbg2Workflow.cwl
    in:
      fastq: zerothstep/reads    
      prefix: prefix
      threads: threads
    out: [contigs]
  quickmerge_canuflye:
    run: cwl/quickmerge.cwl
    scatter: [hybrid_fasta, self_fasta]
    scatterMethod: dotproduct
    in:
      hybrid_fasta: canu/contigs
      self_fasta: flye/contigs
    out: [contigs]
  quickmerge_canuwtdbg2:
    run: cwl/quickmerge.cwl
    scatter: [hybrid_fasta, self_fasta]
    scatterMethod: dotproduct
    in:
      hybrid_fasta: canu/contigs
      self_fasta: wtdbg2/contigs
    out: [contigs]
  quickmerge_flyewtdbg2:
    run: cwl/quickmerge.cwl
    scatter: [hybrid_fasta, self_fasta]
    scatterMethod: dotproduct
    in:
      hybrid_fasta: wtdbg2/contigs
      self_fasta: flye/contigs
    out: [contigs]
