#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  ResourceRequirement:
    coresMax: $(inputs.threads)

baseCommand: ["wtdbg2"]

inputs: 
  fastq:
    doc: "FASTQ input files"
    type: File
    inputBinding:
      position: 8
      prefix: -i
  prefix:
    doc: "Assembly prefix"
    type: string
    inputBinding:
      position: 1
      prefix: -o
  threads:
    doc: ""
    type: int?
    default: 4
    inputBinding:
      position: 4
      prefix: -t

outputs:
  lay:
    doc: ""
    type: File
    outputBinding:
      glob: $(inputs.prefix).ctg.lay.gz
