#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}

baseCommand: ["hifiasm"]
arguments:
  - position: 2
    valueFrom: |
      ${
        return inputs.nanopore ? "--ont" : "";
      }


inputs: 
  fastq:
    doc: "FASTQ input files"
    type: File
    inputBinding:
      position: 99
  nanopore:
    type: boolean
  prefix:
    type: string?
    default: "assembly"
    inputBinding:
      position: 3
      prefix: -o
  threads:
    doc: "Maximum number of compute threads to use by any component of the assembler"
    type: int?
    default: 4
    inputBinding:
      position: 1
      prefix: -t
      separate: false

outputs:
  contigs:
    type: File
    outputBinding:
      glob: $(inputs.prefix).bp.p_ctg.gfa
      outputEval: ${
        var nameParts = inputs.fastq.basename.split(".");
        self[0].basename = nameParts[0] + ".gfa";
        return self; }
