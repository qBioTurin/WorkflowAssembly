#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: "quay.io/biocontainers/transposonpsi:1.0.0--hdfd78af_3"

baseCommand: ["transposonPSI.pl"]
arguments:
  - valueFrom: "nuc"
    position: 2

inputs: 
  fasta:
     type: File
     inputBinding:
       position: 1

outputs:
  bestPerLocus:
    type: File
    outputBinding:
      glob: $(inputs.fasta.basename).TPSI.allHits.chains.bestPerLocus.gff3
