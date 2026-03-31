#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: "vsearch"

baseCommand: ["bash", "/vsearch.sh"]

inputs: 
  fasta:
     type: File[]
     inputBinding:
       position: 1
  threads:
     type: int
     inputBinding:
       position: 2

outputs:
  all_consensi:
    type: File
    outputBinding:
      glob: all_consensi_97.fa
