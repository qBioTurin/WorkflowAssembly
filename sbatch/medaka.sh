#!/bin/bash
#SBATCH --partition=broadwell-booked
#SBATCH -N 1 
#SBATCH --reservation=assembly
srun /opt/adw/bin/adw run -i quay.io/biocontainers/medaka:1.8.0--py38hdaa7744_0 -c "/bin/bash -c 'time {{streamflow_command}}'"
