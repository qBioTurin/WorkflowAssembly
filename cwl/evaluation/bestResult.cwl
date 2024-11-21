#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: qbioturin/assemblyevaluation 

baseCommand: ["python3", "/scripts/main.py", "evaluate"]

inputs: 
  json:
    type: File[]
    inputBinding:
      position: 1
      prefix: --json_file
  fasta:
    type: File[]
    inputBinding: 
      position: 2
      prefix: --fasta_file

outputs:
  best_fasta:
    type: File
    outputBinding:
      glob: "out/*.fasta"
