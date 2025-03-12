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
  mode: string
  lineage: string

outputs: 
  busco_json:
    type: File
    outputSource: busco/busco_json

steps:
   busco:
    run: evaluation/busco.cwl
    in: 
      fasta: fasta 
      mode: mode
      lineage: lineage
      threads: threads
    out: [busco_json]
