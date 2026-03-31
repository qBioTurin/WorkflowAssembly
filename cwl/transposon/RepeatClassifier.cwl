#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.consensi)
        entryname: $(inputs.consensi.basename)
hints:
  DockerRequirement:
    dockerPull: "quay.io/biocontainers/repeatmodeler:2.0.7--pl5321hdfd78af_0"

baseCommand: ["RepeatClassifier"]

inputs: 
  consensi:
     type: File
     inputBinding:
       position: 1
       prefix: -consensi

outputs:
  classified:
    type: File
    outputBinding:
      glob: $(inputs.consensi.basename).classified
