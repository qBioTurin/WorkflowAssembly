#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err 
#SBATCH --reservation=assembly
srun /opt/adw/bin/adw run -i quay.io/biocontainers/bakta:1.12.0--pyhdfd78af_0 -c "/bin/bash -c '{{streamflow_command}}'"
