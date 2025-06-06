#!usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  MultipleInputFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  fastq_directory: Directory
  genome_size: string
  threads: int
  min_coverage: int
  lineage: string
  kingdom: string
  domain:
    - type: enum
      symbols:
        - eukaryotic
        - prokaryotic
  prot_seq: File?
  seq_technology: 
    - type: enum
      symbols:
        - nanopore
        - pacbio
        - pacbio-hifi
  taxon: int

outputs: 
  medaka_canu_out:
    type: File[]
    outputSource: assembly_evaluation/medaka_canu_out
  medaka_flye_out:
    type: File[]
    outputSource: assembly_evaluation/medaka_flye_out
  medaka_wtdbg2_out:
    type: File[]
    outputSource: assembly_evaluation/medaka_wtdbg2_out
  busco_results:
    type:
      type: array
      items:
        type: array
        items: File
    outputSource: assembly_evaluation/busco_json
  prokka_dir:
    type: ["Directory[]", "null"]
    outputSource: assembly_evaluation/prokka_dir
  evaluation-prediction:
    type: ["File[]", "null"]
    outputSource: assembly_evaluation/evaluation-prediction
  braker_gtf:
    type: ["File[]", "null"]
    outputSource: assembly_evaluation/braker_gtf
  proteins:
    type: File[]
    outputSource: assembly_evaluation/proteins
  interpro_result:
    type: File[]
    outputSource: assembly_evaluation/interpro_result
  quickmerge_out:
    type:
      type: array
      items:
        type: array
        items: File
    outputSource: assembly_evaluation/quickmerge_out
  braker_codingseq:
    type: ["File[]", "null"]
    outputSource: assembly_evaluation/braker_codingseq
  enrichment:
    type: File[]
    outputSource: assembly_evaluation/enrichment
  summary:
    type: File[]
    outputSource: assembly_evaluation/summary
  report:
    type: File[]
    outputSource: assembly_evaluation/report
  reactome:
    type: File[]
    outputSource: assembly_evaluation/reactome

steps:
  zerothstep:
    run: cwl/zerothStepSingleEnd.cwl
    in:
      dir: fastq_directory
    out: [reads]
  assembly_evaluation:
    run: cwl/assembly_evaluation_geneprediction.cwl
    scatter: [fastq]
    in:
      fastq: zerothstep/reads
      genome_size: genome_size
      threads: threads
      min_coverage: min_coverage
      lineage: lineage
      kingdom: kingdom
      domain: domain
      prot_seq: prot_seq
      seq_technology: seq_technology
      taxon: taxon
    out: [medaka_canu_out, medaka_flye_out, medaka_wtdbg2_out, busco_json, best_fasta, prokka_dir, evaluation-prediction, braker_gtf, proteins, interpro_result, quickmerge_out, braker_codingseq, enrichment, summary, report, reactome]
