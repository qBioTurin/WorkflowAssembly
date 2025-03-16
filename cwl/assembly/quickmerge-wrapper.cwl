#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  MultipleInputFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  items: File[]

outputs: 
  quickmerge-contigs:
    type: File[]
    outputSource: flatten_output/contigs_2

steps:
  prepare_combinations:
    run:
      class: ExpressionTool
      requirements:
        InlineJavascriptRequirement: {}
      inputs:
        items: 
          type: File[]
      outputs:
        self_fasta: 
          type: File[]
        hybrid: 
          type:
            type: array
            items:
              type: array
              items: File
      expression: |
        ${
          var _self_fasta = [];
          var _hybrid = [];

          inputs.items.forEach(function (file) {
              _self_fasta.push(file);
              _hybrid.push(inputs.items.filter((x) => x !== file));
          });

          return {self_fasta: _self_fasta, hybrid: _hybrid};
        }
    in:
      items: items
    out: [self_fasta, hybrid]
  quickmerge-wrapper:
    scatter: [self_fasta, hybrid]
    in:
      self_fasta: prepare_combinations/self_fasta
      hybrid: prepare_combinations/hybrid
    out: [contigs]
    run:
      class: Workflow
      inputs:
        self_fasta:
          type: File
        hybrid:
          type: File[]
      steps:
        quickmerge:
          scatter: hybrid
          in:
            self_fasta: self_fasta
            hybrid: hybrid
          out: [contigs]
          run: quickmerge.cwl
      outputs:
        contigs:
          type: File[]
          outputSource: quickmerge/contigs
  flatten_output:
    run:
      class: ExpressionTool
      requirements:
        InlineJavascriptRequirement: {}
      inputs:
        nested_files:
          type:
            type: array
            items:
              type: array
              items: File
      outputs:
        contigs_2:
          type: File[]
      expression: |
        ${ return {contigs_2: [].concat.apply([], inputs.nested_files)}; }
    in:
      nested_files: quickmerge-wrapper/contigs
    out: [contigs_2]