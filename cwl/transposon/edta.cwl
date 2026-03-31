#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: "quay.io/biocontainers/edta:2.2.2--hdfd78af_1"

baseCommand: ["EDTA.pl"]
arguments:
  - valueFrom: "--force 1"
    position: 1
    shellQuote: false

inputs: 
  fasta:
     type: File
     inputBinding:
       position: 2
       prefix: --genome
  threads:
     type: int
     inputBinding:
       position: 3
       prefix: --threads

outputs:
  consensi:
    type: File
    outputBinding:
      glob: $(inputs.fasta.basename).mod.EDTA.TElib.fa
