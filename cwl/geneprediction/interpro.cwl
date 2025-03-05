#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: qbioturin/interproscan:5.73-104.0

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    coresMax: $(inputs.threads)
  DockerRequirement:
    dockerPull: qbioturin/interproscan:5.73-104.0
#   InitialWorkDirRequirement:
#     listing:
#     - entryname: /opt/interproscan/data
#       entry: $(inputs.database)
#       writable: false

baseCommand: ["bash", "/opt/interproscan/interproscan.sh", "--pa", "-goterms"]

inputs: 
  proteins:
    type: File
    inputBinding:
      position: 1
      prefix: --input
  threads:
    type: int?
    default: 4
    inputBinding:
      position: 4
      prefix: --cpu
#   database:
#     type: Directory

outputs:
  annotated_protein:
    type: File
    outputBinding:
      glob: "*.tsv"
      outputEval: ${
        var nameParts = inputs.proteins.basename.split(".");
        self[0].basename = nameParts[0] + "_interpro.tsv";
        return self; }
