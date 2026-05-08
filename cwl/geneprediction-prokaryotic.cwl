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
  db_bakta: Directory
  threads: int
  domain:
    - type: enum
      symbols:
        - eukaryotic
        - prokaryotic

outputs: 
  bakta_dir:
    type: Directory
    outputSource: bakta/bakta_dir
  bakta_faa:
    type: File
    outputSource: bakta/bakta_faa
  bakta_fna:
    type: File
    outputSource: bakta/bakta_fna
  amrfinder_tsv:
    type: File
    outputSource: amrfinder/amrfinder_tsv
  amrfinder_faa:
    type: File
    outputSource: amrfinder/amrfinder_faa
  bakta_gff:
    type: File
    outputSource: bakta/bakta_gff

steps:
  bakta:
    run: geneprediction/bakta.cwl
    in:
      fasta: fasta
      db: db_bakta
      threads: threads
    out: [bakta_dir, bakta_faa, bakta_gff, bakta_fna]
  amrfinder:
    run: geneprediction/amrfinder.cwl
    in:
      protein: bakta/bakta_faa
      threads: threads
    out: [amrfinder_tsv, amrfinder_faa]
  