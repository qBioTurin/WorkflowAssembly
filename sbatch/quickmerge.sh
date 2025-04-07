#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err 
srun /opt/adw/bin/adw run -i quay.io/biocontainers/quickmerge:0.3--pl5321hdbdd923_5 -c "/bin/bash -c 'time {{streamflow_command}}'"
