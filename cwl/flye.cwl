#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

doc: |
  Sequencing samples and control

requirements:
  InlineJavascriptRequirement: {}
hints:
  ResourceRequirement:
    coresMax: $(inputs.threads)
  DockerRequirement:
    dockerPull: quay.io/biocontainers/flye:2.9.3--py310h2b6aa90_0 

baseCommand: ["flye"]

inputs: 
  fastq:
    doc: "FASTQ input files"
    type: File
    inputBinding:
      position: 30
  genome_size:
    doc: ""
    type: string
    inputBinding:
      position: 3
      prefix: -g
  nanopore:
    doc: ""
    type: boolean?
    inputBinding:
      position: 5
      prefix: --nano-raw
  pacbio:
    type: boolean?
    inputBinding:
      position: 6
      prefix: --pacbio-raw
  pacbio-hifi:
    type: boolean?
    inputBinding:
      position: 7
      prefix: --pacbio-hifi
  prefix:
    doc: "Assembly prefix"
    type: string
    inputBinding:
      position: 1
      prefix: -o
  threads:
    doc: ""
    type: int?
    default: 4
    inputBinding:
      position: 4
      prefix: --threads

outputs:
  contigs:
    doc: ""
    type: File
    outputBinding:
      glob: $(inputs.prefix)/assembly.fasta
      outputEval: |
        ${
          self[0].basename = inputs.fastq.basename + '_assembly.fasta';
          return self[0]
        }
