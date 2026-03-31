#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  MultipleInputFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}

inputs:
  fasta: File
  threads: int

outputs: 
  RM_consensi:
    type: File
    outputSource: repeatmodeler-run/consensi
  TPSI_consensi:
    type: File
    outputSource: transposonpsi-bedtools/sequences
  EDTA_consensi:
    type: File
    outputSource: edta/consensi
  masked_outputs:
    type: Directory
    outputSource: repeatmasker/masked_outputs
  maskered:
    type: File
    outputSource: repeatmasker/maskered

steps:
  repeatmodeler-buildDatabase:
    run: transposon/RepeatModeler-buildDatabase.cwl
    in:
      fasta: fasta
    out: [database]
  repeatmodeler-run:
    run: transposon/RepeatModeler-run.cwl
    in:
      database: repeatmodeler-buildDatabase/database
      threads: threads
    out: [consensi]
  transposonpsi:
    run: transposon/transposonpsi.cwl
    in:
      fasta: fasta
    out: [bestPerLocus]
  transposonpsi-bedtools:
    run: transposon/transposonpsi-bedtools.cwl
    in:
      fasta: fasta
      bed: transposonpsi/bestPerLocus
    out: [sequences]
  edta:
    run: transposon/edta.cwl
    in:
      fasta: fasta
      threads: threads
    out: [consensi]
  vsearch:
    run: transposon/vsearch.cwl
    in:
      fasta: [repeatmodeler-run/consensi, transposonpsi-bedtools/sequences, edta/consensi]
      threads: threads
    out: [all_consensi]
  repeatclassifier:
    run: transposon/RepeatClassifier.cwl
    in:
      consensi: vsearch/all_consensi
    out: [classified]
  repeatmasker:
    run: transposon/RepeatMasker.cwl
    in:
      fasta: fasta
      lib: repeatclassifier/classified
      threads: threads
    out: [maskered, masked_outputs]