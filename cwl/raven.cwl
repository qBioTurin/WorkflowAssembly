#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  ResourceRequirement:
    coresMax: $(inputs.threads)

baseCommand: ["bash", "/startRaven.sh"]

inputs: 
  fastq:
    doc: "FASTQ input files"
    type: File
    inputBinding:
      position: 2 
  prefix:
    type: string
    inputBinding:
      position: 3
  threads:
    doc: ""
    type: int?
    default: 4
    inputBinding:
      position: 1

outputs:
  contigs:
    doc: ""
    type: File
    outputBinding:
      glob: $(inputs.prefix).fasta
