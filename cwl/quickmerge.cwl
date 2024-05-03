#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

doc: |
  Sequencing samples and control

requirements:
  InlineJavascriptRequirement: {}

baseCommand: ["merge_wrapper.py"]

inputs: 
  hybrid_fasta:
    doc: "The output of a hybrid assembly program such as DBG2OLC"
    type: File
    inputBinding:
      position: 1
  self_fasta:
    doc: "The output of a self assembly program such as PBcR"
    type: File
    inputBinding:
      position: 2

outputs:
  contigs:
    doc: ""
    type: File
    outputBinding:
      glob: merged_out.fasta
