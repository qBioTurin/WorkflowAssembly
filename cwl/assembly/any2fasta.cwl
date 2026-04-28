#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}

baseCommand: ["bash", "/any2fasta.sh"]


inputs: 
  convert:
    doc: "Input file"
    type: File
    inputBinding:
      position: 1

outputs:
  contigs:
    type: File
    outputBinding:
      glob: out.fasta
      outputEval: ${
        var nameParts = inputs.convert.basename.split(".");
        self[0].basename = nameParts[0] + "_hifiasm.fasta";
        return self; }
