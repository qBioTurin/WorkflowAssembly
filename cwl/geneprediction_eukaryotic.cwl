#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  MultipleInputFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  fasta: File
  prefix: string
  threads: int
  eukaryotic: boolean
  prot_seq: File
  mode: string
  lineage: string

outputs: 
  braker_gtf:
    type: File
    outputSource: gene-prediction/braker_gtf
  braker_aa:
    type: File
    outputSource: gene-prediction/braker_aa
  busco_json:
    type: File
    outputSource: evaluation-prediction/busco_json

steps:
  gene-prediction:
    run: geneprediction/braker3.cwl
    in:
      fasta: fasta
      prot_seq: prot_seq 
      threads: threads
      eukaryotic: eukaryotic
    out: [braker_gtf, braker_aa]
  evaluation-prediction:
    run: evaluation.cwl
    in:
      fasta: gene-prediction/braker_aa
      prefix: prefix
      threads: threads
      mode: mode 
      lineage: lineage
    out: [busco_json]
