#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

doc: |
  Sequencing samples and control

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing: [ $(inputs.assembly) ]
hints:
  ResourceRequirement:
    coresMax: $(inputs.threads)

baseCommand: ["medaka_consensus"]

inputs: 
  fastq:
    doc: "fastq"
    type: File
    inputBinding:
      position: 1
      prefix: -i
  assembly:
    doc: "Fasta"
    type: File 
    inputBinding:
      position: 2
      prefix: -d
  threads:
    doc: ""
    type: int?
    default: 4
    inputBinding:
      position: 4
      prefix: -t

outputs:
  contigs:
    doc: ""
    type: File
    outputBinding:
      glob: medaka/consensus.fasta 
      outputEval: |
        ${
          var assemblyName = Array.isArray(inputs.assembly) ? inputs.assembly[0].basename : inputs.assembly.basename;
          var nameParts = assemblyName.split(".");
          self[0].basename = nameParts[0] + "_consensus.fasta";
          return self; 
        }
