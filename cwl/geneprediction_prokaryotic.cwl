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
  threads: int
  kingdom: string
  prokaryotic: boolean
  mode: string
  lineage: string

outputs: 
  prokka_dir:
    type: Directory
    outputSource: gene-prediction/prokka_dir
  busco_json:
    type: File
    outputSource: evaluation-prediction/busco_json

steps:
  gene-prediction:
    run: geneprediction/prokka.cwl
    in:
      fasta: fasta
      kingdom: kingdom
      threads: threads
      prokaryotic: prokaryotic
    out: [prokka_dir, prokka_faa]
  evaluation-prediction:
    run: evaluation.cwl
    in:
      fasta: gene-prediction/prokka_faa
      threads: threads
      mode: mode 
      lineage: lineage
    out: [busco_json]
