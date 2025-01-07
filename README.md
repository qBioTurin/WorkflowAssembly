# WorkflowAssembly
### How to run
To run the workflow in your environment you should install streamflow at the 0.2.0.dev11 version.
If you prefer you can create a python virual environment: 
```
python3 -m venv venv
. ./venv/bin/activate
pip install streamflow==0.2.0.dev11
```
At the moment, you need a SLURM installation in which you have a user with your public key. Then you should change the streamflow.yml file to set your configurations.
Then change the config.yml with your data and parameters.

To run the workflow use following command:
```
bash runStreamflow.sh
```

### Input
- **genome_size**: The genome size of the microorganism
- **fastq_directory**: The directory with all fastq file inside
- **nanopore**: The value should be true if the fastq are sequenced using nanopore technology
- **pacbio**: The value should be true if the fastq are sequenced using pacbio technology
- **pacbio-hifi**: The value should be true if the fastq are sequenced using pacbio-hifi technology
- **prefix**: The name of the analysis
- **threads**: The number of threads to use
- **min_coverage**: Minimum coverage in canu execution
- **lineage**: The lineage of data for busco analysis
- **mode**: The mode for busco analysis

### Output
- **FILENAME_ASSEMBLER_consensus.fasta**: Polished result of assembly fasta obtain by ASSEMBLER
- **FILENAME_ASSEMBLER1_ASSEMBLER2_merged.fasta**: Quickmerge result between the assembly of ASSEMBLER1 and ASSEMBLER2
- **FILENAME_ASSEMBLER1_ASSEMBLER2_merged.json**: Busco result of quickmerge result between the assembly of ASSEMBLER1 and ASSEMBLER2
- **FILENAME_ASSEMBLER1_ASSEMBLER2_merged_prokka**: The prokka results over the best assembly result
