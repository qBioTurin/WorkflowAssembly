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
  seq_technology:
    type: 
    - type: enum
      symbols:
        - nanopore
        - pacbio
        - pacbio-hifi
    inputBinding:
      position: 5
      valueFrom: |
        ${ 
          var mapping = {
            "nanopore": "--nano-raw",
            "pacbio": "--pacbio-raw",
            "pacbio-hifi": "--pacbio-hifi"
          };
          return mapping[inputs.seq_technology];
        }
  prefix:
    doc: "Assembly prefix"
    type: string?
    default: "assembly"
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
          var nameParts = inputs.fastq.basename.split(".");
          self[0].basename = nameParts[0] + '_flye.fasta';
          return self[0]
        }
