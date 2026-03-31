#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: "bedtools"
  InitialWorkDirRequirement:
    listing:
    - entry: $(inputs.fasta)
      writable: false

baseCommand: ["bash", "/getFasta.sh"]

inputs:
  fasta:
    type: File
    inputBinding: 
      position: 1
  bed:
    type: File
    inputBinding: 
      position: 2

outputs:
  sequences:
    type: File
    outputBinding:
      glob: consensi.fa
      outputEval: ${
        var nameParts = inputs.fasta.basename.split(".");
        self[0].basename = nameParts[0] + "_consensi.fa";
        return self; }