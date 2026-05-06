#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}

baseCommand: ["antismash"]
arguments: ["--fullhmmer", "--clusterhmmer", "--tigrfam", "--asf", "--cc-mibig", "--cb-general", "--cb-subclusters", "--cb-knownclusters", "--pfam2go", "--rre", "--smcog-trees", "--tfbs", "--output-dir", "./output"]

inputs: 
  fasta:
    type: File
    inputBinding:
      position: 99
  gff:
    type: File
    inputBinding:
      position: 52
      prefix: --genefinding-gff3
  threads:
    type: int?
    default: 4
    inputBinding:
      position: 51
      prefix: --cpus
  taxon:
    type: string
    inputBinding:
      position: 50
      prefix: --taxon

outputs:
  antismash_dir:
    type: Directory
    outputBinding:
      glob: "./output"
      outputEval: ${
        var nameParts = inputs.fasta.basename.split(".");
        self[0].basename = nameParts[0] + "_antismash";
        return self; }