#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: qbioturin/interproscan:5.73-104.0.4

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: qbioturin/interproscan:5.73-104.0.4

baseCommand: ["python3", "/scripts/p-value.py"]

inputs: 
  interpro:
    type: File
    inputBinding:
      position: 1
      prefix: --interpro
  aminoacid:
    type: File
    inputBinding:
      position: 2
      prefix: --aminoacid
  families:
    type: string?
    default: "/ref/families.tsv"
    inputBinding:
      position: 3
      prefix: --families
  go:
    type: string?
    default: "/ref/go.obo"
    inputBinding:
      position: 4
      prefix: --go
  taxon:
    type: int
    inputBinding:
      position: 5
      prefix: --taxon

outputs:
  enrichment:
    type: File
    outputBinding:
      glob: "results.tsv"
      outputEval: ${
        var nameParts = inputs.interpro.basename.split(".");
        self[0].basename = nameParts[0] + "_interpro.tsv";
        return self; }
