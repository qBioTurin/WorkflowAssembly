#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  ResourceRequirement:
    coresMax: $(inputs.threads)
  DockerRequirement:
    dockerPull: teambraker/braker3 

baseCommand: ["braker.pl", "--fungus"]

inputs: 
  fasta:
    type: File
    inputBinding:
      position: 30
      prefix: --genome
  prot_seq:
    type: File
    inputBinding:
      position: 2
      prefix: --prot_seq
  threads:
    type: int?
    default: 4
    inputBinding:
      position: 4
      prefix: --threads
  domain:
    type: string

outputs:
  braker_gtf:
    type: File
    outputBinding:
      glob: braker/braker.gtf 
      outputEval: ${
        var nameParts = inputs.fasta.basename.split(".");
        self[0].basename = nameParts[0] + "_braker.gtf";
        return self; } 
  braker_aa:
    type: File
    outputBinding:
      glob: braker/braker.aa
      outputEval: ${
        var nameParts = inputs.fasta.basename.split(".");
        self[0].basename = nameParts[0] + "_braker.aa";
        return self; } 
