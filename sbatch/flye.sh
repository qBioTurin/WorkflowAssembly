#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
srun /opt/adw/bin/adw run -i quay.io/biocontainers/flye:2.9.2--py310h2b6aa90_2  -c "/bin/bash -c '{{streamflow_command}}'"
