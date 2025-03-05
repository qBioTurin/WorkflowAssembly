#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
srun /opt/adw/bin/adw run -i quay.io/biocontainers/quickmerge:0.3--pl5321hdbdd923_5 -c "/bin/bash -c 'time {{streamflow_command}}'"
