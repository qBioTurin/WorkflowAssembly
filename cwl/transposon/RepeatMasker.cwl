#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: "quay.io/biocontainers/repeatmodeler:2.0.7--pl5321hdfd78af_0"

baseCommand: ["RepeatMasker"]
arguments:
  - -xsmall
  - -a
  - -gff
  - -html
  - -ace
  - -dir
  - valueFrom: $(inputs.fasta.basename)_repeatmasker
    shellQuote: false

inputs: 
  fasta:
    type: File
    inputBinding:
      position: 99
  lib: 
    type: File
    inputBinding:
      position: 2
      prefix: -lib
  threads:
    type: int
    inputBinding:
      position: 1
      prefix: -pa

outputs:
  maskered:
    type: File
    outputBinding:
      glob: $(inputs.fasta.basename)_repeatmasker/$(inputs.fasta.basename).masked
  masked_outputs:
    type: Directory
    outputBinding:
      glob: $(inputs.fasta.basename)_repeatmasker/
