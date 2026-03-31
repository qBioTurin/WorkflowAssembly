#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: "quay.io/biocontainers/repeatmodeler:2.0.7--pl5321hdfd78af_0"

baseCommand: ["BuildDatabase"]

inputs: 
  name:
    type: string
    default: "database_RM"
    inputBinding:
      position: 1
      prefix: -name
  fasta:
    type: File
    inputBinding: 
      position: 2

outputs:
  database:
    type: File
    outputBinding:
      glob: $(inputs.name).nhr
    secondaryFiles:
      - ^.nin
      - ^.njs
      - ^.nnd
      - ^.nni
      - ^.nog
      - ^.nsq
      - ^.translation
