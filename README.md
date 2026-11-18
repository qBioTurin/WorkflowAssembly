# WorkflowAssembly

Assembly and annotation workflow for long-read microbial genomes. The
repository can be run on its own: it does not require WorkflowService,
PostgreSQL, S3, or the web application.

## Requirements

- Python 3.11
- StreamFlow `0.2.0.dev11`
- access to a Slurm cluster configured in a StreamFlow YAML file

```bash
python3.11 -m venv .venv
. .venv/bin/activate
pip install streamflow==0.2.0.dev11
```

Copy `streamflow.yml`, adapt its SSH, Slurm, work-directory, and service
settings to the target infrastructure, and keep it outside version control if
it contains site-specific information.

## Standalone launcher

`bin/assembly-run` validates the selected branch, creates an isolated run
workspace, writes `config.yml`, and starts StreamFlow. It includes only the
reference used by the selected domain:

| Domain | Required reference | Not used |
| --- | --- | --- |
| `prokaryotic` | Bakta database | protein FASTA |
| `eukaryotic` | one protein FASTA | Bakta database |

### Local reference transferred by StreamFlow

Use `transfer` when the reference exists on the machine that starts
StreamFlow. The reference is represented as a normal CWL `File` or `Directory`
and StreamFlow stages it to the compute deployment.

```bash
bin/assembly-run \
  --domain prokaryotic \
  --fastq-directory /data/reads/klebsiella \
  --seq-technology nanopore \
  --lineage enterobacterales \
  --taxon 570 \
  --bakta-db /data/references/bakta \
  --reference-mode transfer \
  --streamflow-config /etc/workflow-assembly/streamflow.yml \
  --output ./results/klebsiella
```

### Reference already installed on the HPC

Use `hpc-shared` when compute nodes already see the reference path. The path is
passed as an opaque CWL string, so the launcher machine does not need to mount,
copy, or download the database.

```bash
bin/assembly-run \
  --domain eukaryotic \
  --fastq-directory /data/reads/candida \
  --seq-technology nanopore \
  --lineage ascomycota \
  --taxon 498019 \
  --protein-fasta /storage/data/uniprot/uniprotkb_ascomycota.fasta \
  --reference-mode hpc-shared \
  --streamflow-config /etc/workflow-assembly/streamflow.yml \
  --output ./results/candida
```

The compute-side path must be visible with the same value inside the job and
inside the tool container. `hpc-shared` deliberately does not check it from
the launcher host.

Use `--prepare-only` to inspect the generated workspace without starting
StreamFlow. By default it is created next to the output as
`.OUTPUT_NAME.workflow-run`; use `--workspace` to choose another location.
Existing workspaces are never overwritten.

```bash
bin/assembly-run --help
python3.11 -m unittest discover -s tests -v
```

## Running the CWL directly

The canonical `workflow.cwl` keeps portable CWL `File`/`Directory` reference
types. `db_bakta` and `prot_seq` are optional at the top level, and the
`validate-references` step enforces the domain-specific requirement before any
assembly job starts. Consequently, a direct prokaryotic settings file should
omit `prot_seq`, while an eukaryotic one should omit `db_bakta`.

The checked-in `config.yml`, `streamflow.yml`, and `runStreamflow.sh` remain a
minimal direct-run example:

```bash
bash runStreamflow.sh
```

## Main inputs

- `genome_size`: optional expected genome size
- `fastq_directory`: directory containing FASTQ files
- `seq_technology`: `nanopore`, `pacbio`, or `pacbio-hifi`
- `threads`: number of threads
- `min_coverage`: minimum coverage used by Canu
- `lineage`: BUSCO lineage
- `kingdom`: kingdom used by the prokaryotic annotation branch
- `domain`: `prokaryotic` or `eukaryotic`
- `taxon`: taxonomy identifier
- `db_bakta`: Bakta database, only for `prokaryotic`
- `prot_seq`: protein FASTA, only for `eukaryotic`

## Main outputs

- polished assemblies from the configured assemblers
- QuickMerge assemblies and BUSCO evaluations
- Bakta outputs for prokaryotic runs
- BRAKER and transposon-analysis outputs for eukaryotic runs
- InterPro, enrichment, summary, report, and Reactome outputs
