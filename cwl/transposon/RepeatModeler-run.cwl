#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: "quay.io/biocontainers/repeatmodeler:2.0.7--pl5321hdfd78af_0"
  InitialWorkDirRequirement:
    listing:
      - $(inputs.database)
      - $(inputs.database.secondaryFiles)

baseCommand: ["RepeatModeler", "-LTRStruct"]

inputs: 
  database:
     type: File
     inputBinding:
       position: 1
       prefix: -database
       valueFrom: $(inputs.database.basename.replace(/\.nhr$/, ''))
  threads:
    type: int
    inputBinding: 
      position: 2
      prefix: -threads

outputs:
  consensi:
    type: File
    outputBinding:
      glob: RM*/consensi.fa
