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
  eukaryotic: boolean
  prot_seq: File?

outputs: 
  prokka_dir:
    type: ["Directory", "null"]
    outputSource: gene-prediction-prokaryotic/prokka_dir
  braker_gtf:
    type: ["File", "null"]
    outputSource: gene-prediction-eukaryotic/braker_gtf
  proteins:
    type: File
    outputSource:
      - gene-prediction-eukaryotic/braker_aa
      - gene-prediction-prokaryotic/prokka_faa
    pickValue: first_non_null

steps:
  gene-prediction-eukaryotic:
    run: geneprediction/braker3.cwl
    in:
      fasta: fasta
      prot_seq: prot_seq
      threads: threads
      eukaryotic: eukaryotic
    out: [braker_gtf, braker_aa]
    when: $(inputs.eukaryotic)
  gene-prediction-prokaryotic:
    run: geneprediction/prokka.cwl
    in:
      fasta: fasta
      threads: threads
      kingdom: kingdom 
      prokaryotic: prokaryotic
    out: [prokka_dir, prokka_faa]
    when: $(inputs.prokaryotic)
