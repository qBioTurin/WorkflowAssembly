#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  ResourceRequirement:
    coresMax: $(inputs.threads)

baseCommand: ["wtpoa-cns"]
arguments:
  - position: 1
    shellQuote: false
    prefix: -o
    valueFrom: $(inputs.prefix).fasta

inputs: 
  lay:
    type: File
    inputBinding:
      position: 8
      prefix: -i
  prefix:
    doc: "Assembly prefix"
    type: string?
    default: "assembly"
  threads:
    doc: ""
    type: int?
    default: 4
    inputBinding:
      position: 4
      prefix: -t

outputs:
  fasta:
    doc: ""
    type: File
    outputBinding:
      glob: $(inputs.prefix).fasta
      outputEval: ${
        var nameParts = inputs.lay.basename.split(".");
        self[0].basename = nameParts[0] + "_wtdbg2.fasta";
        return self; }
