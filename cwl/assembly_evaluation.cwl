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
  threads: int
  pacbio: boolean
  pacbio-hifi: boolean 
  min_coverage: int
  mode: string
  lineage: string

outputs: 
  medaka_canu_out:
    type: File
    outputSource: assembly/medaka_canu_out
  medaka_flye_out:
    type: File
    outputSource: assembly/medaka_flye_out
  medaka_wtdbg2_out:
    type: File
    outputSource: assembly/medaka_wtdbg2_out
  quickmerge_canuflye_out:
    type: File
    outputSource: assembly/quickmerge_canuflye_out
  quickmerge_canuwtdbg2_out:
    type: File
    outputSource: assembly/quickmerge_canuwtdbg2_out
  quickmerge_flyewtdbg2_out:
    type: File
    outputSource: assembly/quickmerge_flyewtdbg2_out
  busco_json:
    type: File[]
    outputSource: evaluation/busco_json
  best_fasta:
    type: File
    outputSource: best-result/best_fasta

steps:
  assembly:
    run: assembly.cwl
    in:
      fastq: fastq
      genome_size: genome_size
      nanopore: nanopore
      prefix: prefix
      threads: threads
      pacbio: pacbio
      pacbio-hifi: pacbio-hifi
      min_coverage: min_coverage
    out: [medaka_canu_out, medaka_flye_out, medaka_wtdbg2_out, quickmerge_canuflye_out, quickmerge_canuwtdbg2_out, quickmerge_flyewtdbg2_out]
  evaluation:
    run: evaluation.cwl
    scatter: [fasta]
    in:
      fasta:  
        source: [assembly/quickmerge_canuflye_out, assembly/quickmerge_canuwtdbg2_out, assembly/quickmerge_flyewtdbg2_out]
        linkMerge: merge_flattened
      prefix: prefix
      threads: threads
      mode: mode
      lineage: lineage
    out: [busco_json]
  best-result:
    run: evaluation/bestResult.cwl
    in:
      json: evaluation/busco_json
      fasta: 
        source: [assembly/quickmerge_canuflye_out, assembly/quickmerge_canuwtdbg2_out, assembly/quickmerge_flyewtdbg2_out]
        linkMerge: merge_flattened
    out: [best_fasta]
