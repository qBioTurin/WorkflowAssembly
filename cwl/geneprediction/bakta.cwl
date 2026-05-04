#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}

baseCommand: ["bakta"]
arguments:
  - valueFrom: "./output"
    prefix: "--output"
    position: 2

inputs: 
  fasta:
    type: File
    inputBinding:
      position: 30
  db:
    type: Directory
    inputBinding:
      position: 1
      prefix: --db
  threads:
    type: int?
    default: 4
    inputBinding:
      position: 4
      prefix: --threads
  domain:
    type: string

outputs:
  bakta_dir:
    type: Directory
    outputBinding:
      glob: "./output"
      outputEval: ${
        var nameParts = inputs.fasta.basename.split(".");
        self[0].basename = nameParts[0] + "_bakta";
        return self; }
  bakta_faa:
    type: File
    outputBinding:
      glob: "./output/*.faa"
      outputEval: |
        ${
          var realFaa = self.filter(function(f) { 
            return !f.basename.includes("hypotheticals"); 
          })[0];
          
          var nameParts = inputs.fasta.basename.split(".");
          realFaa.basename = nameParts[0] + "_bakta.faa";
          
          return realFaa;
        }
