#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  ResourceRequirement:
    coresMax: $(inputs.threads)
  DockerRequirement:
    dockerPull: ezlabgva/busco:v5.8.0_cv1 

baseCommand: ["busco"]

inputs: 
  fasta:
    type: File
    inputBinding:
      position: 30
      prefix: -i
  prefix:
    type: string
    inputBinding: 
      position: 5
      prefix: -o
  mode:
    type: string
    inputBinding:
      position: 1
      prefix: -m
  lineage:
    type: string
    inputBinding:
      position: 2
      prefix: -l
  threads:
    type: int?
    default: 4
    inputBinding:
      position: 4
      prefix: -c

outputs:
  busco_json:
    type: File
    outputBinding:
      glob: "$(inputs.prefix)/*.json"
      outputEval: ${
          self[0].basename = inputs.fasta.nameroot + ".json";
          return self; } 
