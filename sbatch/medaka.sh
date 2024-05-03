#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
srun /opt/adw/bin/adw run -i quay.io/biocontainers/medaka:1.8.0--py38hdaa7744_0 -c "/bin/bash -c '{{streamflow_command}}'"
