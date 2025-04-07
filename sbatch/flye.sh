#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err 
srun /opt/adw/bin/adw run -i quay.io/biocontainers/flye:2.9.2--py310h2b6aa90_2  -c "/bin/bash -c 'time {{streamflow_command}}'"
