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
  fastq: File
  genome_size: string?
  threads: int
  min_coverage: int?
  lineage: string
  kingdom: string
  prot_seq: File?
  domain:
    - type: enum
      symbols:
        - eukaryotic
        - prokaryotic
  seq_technology: 
    - type: enum
      symbols:
        - nanopore
        - pacbio
        - pacbio-hifi
  taxon: int
  db_bakta: Directory

outputs: 
  medaka_canu_out:
    type: File
    outputSource: assembly/medaka_canu_out
  medaka_flye_out:
    type: File
    outputSource: assembly/medaka_flye_out
  medaka_wtdbg2_out:
    type: File
    outputSource: assembly/medaka_wtdbg2_out
  medaka_hifiasm_out:
    type: File
    outputSource: assembly/medaka_hifiasm_out
  busco_json:
    type: File[]
    outputSource: evaluation/busco_json
  best_fasta:
    type: File
    outputSource: best-result/best_fasta
  bakta_dir:
    type:  ["null", "Directory"]
    outputSource: geneprediction/bakta_dir
  evaluation-prediction:
    type:  File
    outputSource: evaluation-prediction/busco_json
  braker_gtf:
    type:  ["null", "File"]
    outputSource: geneprediction/braker_gtf
  proteins:
    type:  File
    outputSource: geneprediction/proteins
  interpro_result:
    type: File
    outputSource: interpro/annotated_protein
  quickmerge_out:
    type: File[]
    outputSource: assembly/quickmerge_out
  braker_codingseq:
    type:  ["null", "File"]
    outputSource: geneprediction/braker_codingseq
  enrichment:
    type: File
    outputSource: go_enrich/enrichment
  summary:
    type: File
    outputSource: postprocessing/summary
  report:
    type: File
    outputSource: postprocessing/report
  reactome:
    type: File
    outputSource: postprocessing/reactome
  RM_consensi:
    type: File?
    outputSource: geneprediction/RM_consensi
  TPSI_consensi:
    type: File?
    outputSource: geneprediction/TPSI_consensi
  EDTA_consensi:
    type: File?
    outputSource: geneprediction/EDTA_consensi
  masked_outputs:
    type: Directory?
    outputSource: geneprediction/masked_outputs

steps:
  lrge:
    run: assembly/lrge.cwl
    in:
      fastq: fastq
      threads: threads
      _genome_size: genome_size
      platform: 
        source: seq_technology
        valueFrom: |
          ${
            return self == "nanopore" ? "ont" : "pb";
          }
    out: [genome_size]
    when: $(inputs._genome_size == null)
  assembly:
    run: assembly.cwl
    in:
      fastq: fastq
      genome_size: 
        source: [genome_size, lrge/genome_size]
        valueFrom: |
          ${
            return self[0] != null ? self[0] : self[1];
          }
      threads: threads
      min_coverage: min_coverage
      seq_technology: seq_technology
    out: [medaka_canu_out, medaka_flye_out, medaka_wtdbg2_out, medaka_hifiasm_out, quickmerge_out]
  evaluation:
    run: evaluation.cwl
    scatter: [fasta]
    in:
      fasta:
        linkMerge: merge_flattened
        source: 
          - assembly/quickmerge_out
          - assembly/medaka_canu_out
          - assembly/medaka_flye_out
          - assembly/medaka_wtdbg2_out
          - assembly/medaka_hifiasm_out
      threads: threads
      mode:
        default: "genome"
      lineage: lineage
    out: [busco_json]
  best-result:
    run: evaluation/bestResult.cwl
    in:
      json: evaluation/busco_json
      genome_size: 
        source: [genome_size, lrge/genome_size]
        valueFrom: |
          ${
            return self[0] != null ? self[0] : self[1];
          }
      fasta:
        linkMerge: merge_flattened
        source: 
          - assembly/quickmerge_out
          - assembly/medaka_canu_out
          - assembly/medaka_flye_out
          - assembly/medaka_wtdbg2_out
          - assembly/medaka_hifiasm_out
    out: [best_fasta]
  geneprediction:
    run: geneprediction.cwl
    in:
      fasta: best-result/best_fasta
      kingdom: kingdom
      threads: threads
      domain: domain
      prot_seq: prot_seq
      db_bakta: db_bakta
    out: [bakta_dir, braker_gtf, proteins, braker_codingseq, RM_consensi, TPSI_consensi, EDTA_consensi, masked_outputs]
  evaluation-prediction:
    run: evaluation.cwl
    in:
      fasta: geneprediction/proteins
      threads: threads
      mode: 
        default: "prot" 
      lineage: lineage
    out: [busco_json]
  clean-proteins:
    run: geneprediction/clean_protein_file.cwl
    in:
      input_file: geneprediction/proteins
    out: [cleaned_file]
  interpro:
    run: geneprediction/interpro.cwl
    in:
      proteins: clean-proteins/cleaned_file
      threads: threads
    out: [annotated_protein]
  go_enrich:
    run: geneprediction/go_enrich.cwl
    in:
      interpro: interpro/annotated_protein
      aminoacid: clean-proteins/cleaned_file
      taxon: taxon
    out: [enrichment]
  postprocessing:
    run: geneprediction/postprocessing.cwl
    in:
      interpro: interpro/annotated_protein
      aminoacid: clean-proteins/cleaned_file
    out: [summary, report, reactome]
