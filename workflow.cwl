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
  mode: string
  lineage: string

outputs: 
  medaka_canu_out:
    type: File[]
    outputSource: canu/contigs
  medaka_flye_out:
    type: File[]
    outputSource: flye/contigs
  medaka_wtdbg2_out:
    type: File[]
    outputSource: wtdbg2/contigs
  quickmerge_canuflye_out:
    type: File[]
    outputSource: quickmerge_canuflye/contigs
  quickmerge_canuwtdbg2_out:
    type: File[]
    outputSource: quickmerge_canuwtdbg2/contigs
  quickmerge_flyewtdbg2_out:
    type: File[]
    outputSource: quickmerge_flyewtdbg2/contigs
  busco_results:
    type: File[]
    outputSource: busco/busco_json
    

steps:
  zerothstep:
    run: cwl/zerothStepSingleEnd.cwl
    in:
      dir: fastq_directory
    out: [reads]
  canu:
    run: cwl/canuWorkflow.cwl
    in:
      fastq: zerothstep/reads
      genome_size: genome_size
      nanopore: nanopore
      prefix: prefix
      threads: threads
      pacbio: pacbio
      pacbio-hifi: pacbio-hifi
      min_coverage: min_coverage
    out: [contigs]
  flye:
    run: cwl/flyeWorkflow.cwl
    in:
      fastq: zerothstep/reads
      genome_size: genome_size
      nanopore: nanopore
      prefix: prefix
      pacbio: pacbio                                                                                                                                    
      pacbio-hifi: pacbio-hifi
      threads: threads
    out: [contigs]
  wtdbg2:
    run: cwl/wtdbg2Workflow.cwl
    in:
      fastq: zerothstep/reads    
      prefix: prefix
      threads: threads
      genome_size: genome_size
    out: [contigs]
  quickmerge_canuflye:
    run: cwl/quickmerge.cwl
    scatter: [hybrid_fasta, self_fasta]
    scatterMethod: dotproduct
    in:
      hybrid_fasta: canu/contigs
      self_fasta: flye/contigs
    out: [contigs]
  quickmerge_canuwtdbg2:
    run: cwl/quickmerge.cwl
    scatter: [hybrid_fasta, self_fasta]
    scatterMethod: dotproduct
    in:
      hybrid_fasta: canu/contigs
      self_fasta: wtdbg2/contigs
    out: [contigs]
  quickmerge_flyewtdbg2:
    run: cwl/quickmerge.cwl
    scatter: [hybrid_fasta, self_fasta]
    scatterMethod: dotproduct
    in:
      hybrid_fasta: wtdbg2/contigs
      self_fasta: flye/contigs
    out: [contigs]
  busco:
    run: cwl/busco.cwl
    scatter: [fasta]
    in: 
      fasta: 
        source: [quickmerge_canuflye/contigs, quickmerge_canuwtdbg2/contigs, quickmerge_flyewtdbg2/contigs]
        linkMerge: merge_flattened
      prefix: prefix
      mode: mode
      lineage: lineage
      threads: threads
    out: [busco_json]
