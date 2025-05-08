#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}

baseCommand: ["python3", "/main.py"]

inputs: 
  interpro:
    type: File
    inputBinding:
      position: 1
  families:
    type: string?
    default: "/input/signatures.tsv"
    inputBinding:
      position: 2
  outputdir:
    type: string?
    default: "."
    inputBinding:
      position: 3

outputs:
  summary:
    type: File
    outputBinding:
      glob: "summary.tsv"
      outputEval: ${
        var nameParts = inputs.interpro.basename.split(".");
        self[0].basename = nameParts[0] + "_summary.tsv";
        return self; }
  report:
    type: File
    outputBinding:
      glob: "report.tsv"
      outputEval: ${
        var nameParts = inputs.interpro.basename.split(".");
        self[0].basename = nameParts[0] + "_report.tsv";
        return self; }
  reactome:
    type: File
    outputBinding:
      glob: "reactome.tsv"
      outputEval: ${
        var nameParts = inputs.interpro.basename.split(".");
        self[0].basename = nameParts[0] + "_reactome.tsv";
        return self; }


