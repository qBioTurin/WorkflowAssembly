#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}

baseCommand: ["amrfinder"]
arguments: 
  - "--plus"
  - "--report_all_equal"
  - valueFrom: $(inputs.protein.basename)
    prefix: "--name"
  - "-o"
  - "output.amrfinder.tsv" 
  - "--protein_output"
  - "output.amrfinder.faa"

inputs: 
  protein:
    type: File
    inputBinding:
      position: 1
      prefix: -p
  threads:
    type: int?
    default: 2
    inputBinding:
      position: 51
      prefix: --threads

outputs:
  amrfinder_tsv:
    type: File
    outputBinding:
      glob: "./output.amrfinder.tsv"
      outputEval: ${
        var nameParts = inputs.protein.basename.split(".");
        self[0].basename = nameParts[0] + "_amrfinder.tsv";
        return self; }
  amrfinder_faa:
    type: File
    outputBinding:
      glob: "./output.amrfinder.faa"
      outputEval: ${
        var nameParts = inputs.protein.basename.split(".");
        self[0].basename = nameParts[0] + "_amrfinder.faa";
        return self; }