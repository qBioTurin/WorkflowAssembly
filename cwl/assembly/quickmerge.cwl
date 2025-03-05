#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

doc: |
  Sequencing samples and control

requirements:
  InlineJavascriptRequirement: {}

baseCommand: ["merge_wrapper.py"]

inputs: 
  hybrid:
    doc: "The output of a hybrid assembly program such as DBG2OLC"
    type: File
    inputBinding:
      position: 1
  self_fasta:
    doc: "The output of a self assembly program such as PBcR"
    type: File
    inputBinding:
      position: 2

outputs:
  contigs:
    doc: ""
    type: File
    outputBinding:
      glob: merged_out.fasta
      outputEval: ${
          var hybrid_name = inputs.hybrid.basename;
          var self_fasta_name = inputs.self_fasta.basename;
          var nameParts = hybrid_name.split('.')[0].split('_').slice(0, -2).join('_');
          
          var assemblyTech = "";
          
          if (hybrid_name.includes("canu")) {
              assemblyTech = "canu";
          } else if (hybrid_name.includes("flye")) {
              assemblyTech = "flye";
          } else if (hybrid_name.includes("wtdbg2")) {
              assemblyTech = "wtdbg2";
          }

          if (self_fasta_name.includes("canu")) {
              assemblyTech += "_canu";
          } else if (self_fasta_name.includes("flye")) {
              assemblyTech += "_flye";
          } else if (self_fasta_name.includes("wtdbg2")) {
              assemblyTech += "_wtdbg2";
          }

          self[0].basename = nameParts + "_" + assemblyTech + "_merged.fasta";
          return self; }
