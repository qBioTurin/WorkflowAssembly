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
  lineage: string
  kingdom: string
  prokaryotic: boolean
  eukaryotic: boolean
  prot_seq: File?
  seq_technology: 
    - type: enum
      symbols:
        - nanopore
        - pacbio
        - pacbio-hifi

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
  busco_json:
    type: File[]
    outputSource: evaluation/busco_json
  best_fasta:
    type: File
    outputSource: best-result/best_fasta
  prokka_dir:
    type:  ["null", "Directory"]
    outputSource: geneprediction/prokka_dir
  evaluation-prediction:
    type:  File
    outputSource: evaluation-prediction/busco_json
  braker_gtf:
    type:  ["null", "File"]
    outputSource: geneprediction/braker_gtf
  proteins:
    type:  File
    outputSource: geneprediction/proteins
  interpro_result:
    type: File
    outputSource: interpro/annotated_protein
  quickmerge_out:
    type: File[]
    outputSource: assembly/quickmerge_out

steps:
  assembly:
    run: assembly.cwl
    in:
      fastq: fastq
      genome_size: genome_size
      threads: threads
      min_coverage: min_coverage
      seq_technology: seq_technology
    out: [medaka_canu_out, medaka_flye_out, medaka_wtdbg2_out, quickmerge_out]
  evaluation:
    run: evaluation.cwl
    scatter: [fasta]
    in:
      fasta: assembly/quickmerge_out
      threads: threads
      mode:
        default: "genome"
      lineage: lineage
    out: [busco_json]
  best-result:
    run: evaluation/bestResult.cwl
    in:
      json: evaluation/busco_json
      fasta: assembly/quickmerge_out
    out: [best_fasta]
  geneprediction:
    run: geneprediction.cwl
    in:
      fasta: best-result/best_fasta
      kingdom: kingdom
      threads: threads
      prokaryotic: prokaryotic
      eukaryotic: eukaryotic
      prot_seq: prot_seq
    out: [prokka_dir, braker_gtf, proteins]
  evaluation-prediction:
    run: evaluation.cwl
    in:
      fasta: geneprediction/proteins
      threads: threads
      mode: 
        default: "prot" 
      lineage: lineage
    out: [busco_json]
  clean-proteins:
    run: geneprediction/clean_protein_file.cwl
    in:
      input_file: geneprediction/proteins
    out: [cleaned_file]
  interpro:
    run: geneprediction/interpro.cwl
    in:
      proteins: clean-proteins/cleaned_file
      threads: threads
    out: [annotated_protein]
