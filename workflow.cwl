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
  nanopore: boolean
  prefix: string
  threads: int
  pacbio: boolean
  pacbio-hifi: boolean
  min_coverage: int
  mode_genome: string
  mode_protein: string
  lineage: string
  kingdom: string
  prokaryotic: boolean

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
  quickmerge_canuflye_out:
    type: File[]
    outputSource: assembly_evaluation/quickmerge_canuflye_out
  quickmerge_canuwtdbg2_out:
    type: File[]
    outputSource: assembly_evaluation/quickmerge_canuwtdbg2_out
  quickmerge_flyewtdbg2_out:
    type: File[]
    outputSource: assembly_evaluation/quickmerge_flyewtdbg2_out
  busco_results:
    type:
      type: array
      items:
        type: array
        items: File
    outputSource: assembly_evaluation/busco_json
  best_fastas:
    type: File[]
    outputSource: assembly_evaluation/best_fasta
  prokka_dir:
    type: ["Directory[]", "null"]
    outputSource: assembly_evaluation/prokka_dir
  evaluation-prediction:
    type: ["File[]", "null"]
    outputSource: assembly_evaluation/evaluation-prediction

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
      nanopore: nanopore
      prefix: prefix
      threads: threads
      pacbio: pacbio
      pacbio-hifi: pacbio-hifi 
      min_coverage: min_coverage
      mode_genome: mode_genome
      mode_protein: mode_protein
      lineage: lineage
      kingdom: kingdom
      prokaryotic: prokaryotic
    out: [medaka_canu_out, medaka_flye_out, medaka_wtdbg2_out, quickmerge_canuflye_out, quickmerge_canuwtdbg2_out, quickmerge_flyewtdbg2_out, busco_json, best_fasta, prokka_dir, evaluation-prediction]
