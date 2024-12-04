#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
hints:
  ResourceRequirement:
    coresMax: $(inputs.threads)
  DockerRequirement:
    dockerPull: staphb/prokka 

baseCommand: ["prokka"]

inputs: 
  fasta:
    type: File
    inputBinding:
      position: 30
  prefix:
    type: string
    inputBinding:
      position: 1
      prefix: --prefix
  kingdom:
    type: string
    inputBinding:
      position: 2
      prefix: --kingdom
  threads:
    type: int?
    default: 4
    inputBinding:
      position: 4
      prefix: --cpus
  prokaryotic:
    type: boolean

outputs:
  prokka_dir:
    type: Directory
    outputBinding:
      glob: $(inputs.prefix)
      outputEval: ${
        var nameParts = inputs.fasta.basename.split(".");
        self[0].basename = nameParts[0] + "_prokka";
        return self; }