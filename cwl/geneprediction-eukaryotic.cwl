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
  prot_seq: File?
  domain:
    - type: enum
      symbols:
        - eukaryotic
        - prokaryotic

outputs: 
  braker_gtf:
    type: File
    outputSource: gene-prediction-eukaryotic/braker_gtf
  braker_codingseq:
    type: File
    outputSource: gene-prediction-eukaryotic/braker_codingseq
  braker_aa:
    type: File
    outputSource: gene-prediction-eukaryotic/braker_aa
  RM_consensi:
    type: File
    outputSource: transposon/RM_consensi
  TPSI_consensi:
    type: File
    outputSource: transposon/TPSI_consensi
  EDTA_consensi:
    type: File
    outputSource: transposon/EDTA_consensi
  masked_outputs:
    type: Directory
    outputSource: transposon/masked_outputs

steps:
  transposon:
    run: transposon.cwl
    in:
      fasta: fasta
      threads: threads
    out: [RM_consensi, TPSI_consensi, EDTA_consensi, masked_outputs, maskered]
  gene-prediction-eukaryotic:
    run: geneprediction/braker3.cwl
    in:
      fasta: transposon/maskered
      prot_seq: prot_seq
      threads: threads
      domain: domain
    out: [braker_gtf, braker_aa, braker_codingseq]
