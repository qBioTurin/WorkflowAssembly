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

baseCommand: ["canu"]

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
      prefix: genomeSize=
      separate: false
  nanopore:
    doc: ""
    type: boolean?
    inputBinding:
      position: 6
      prefix: -nanopore
  pacbio:
    doc: ""
    type: boolean?
    inputBinding:
      position: 7
      prefix: -pacbio
  pacbio-hifi:
    doc: ""
    type: boolean?
    inputBinding:
      position: 8
      prefix: -pacbio-hifi
  min_coverage:
    doc: ""
    type: int?
    inputBinding:
      position: 9
      prefix: minInputCoverage=
      separate: false
  prefix:
    doc: "Assembly prefix"
    type: string
    inputBinding:
      position: 1
      prefix: -p
  threads:
    doc: "Maximum number of compute threads to use by any component of the assembler"
    type: int?
    default: 4
    inputBinding:
      position: 5
      prefix: maxThreads=
      separate: false

outputs:
  contigs:
    doc: ""
    type: File
    outputBinding:
      glob: $(inputs.prefix).contigs.fasta
