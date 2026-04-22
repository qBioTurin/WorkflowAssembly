#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}

baseCommand: ["lrge"]
arguments:
  - position: 1
    prefix: "--output"
    valueFrom: "sample.txt"
  - position: 2
    prefix: "-n"
    valueFrom: "100000"

inputs: 
  fastq:
    doc: "FASTQ input files"
    type: File
    inputBinding:
      position: 30
  platform:
    type: string
    default: "ont"
    inputBinding:
      position: 10
      prefix: "-P"
  threads:
    type: int?
    default: 4
    inputBinding:
      position: 20
      prefix: "-t"
  seed:
    type: int?
    default: 42
    inputBinding:
      position: 5
      prefix: "-s"
  _genome_size:
    type: string?

outputs:
  genome_size:
    type: string
    outputBinding:
      glob: "sample.txt"
      loadContents: true
      outputEval: |
        ${
          var val = parseInt(self[0].contents.trim());
          if (val >= 1000000) {
            return (val / 1000000).toFixed(1) + "m";
          } else if (val >= 1000) {
            return (val / 1000).toFixed(1) + "k";
          }
          return val.toString();
        }
