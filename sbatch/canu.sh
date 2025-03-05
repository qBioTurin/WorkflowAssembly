#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
srun /opt/adw/bin/adw run -i quay.io/biocontainers/canu:2.2--ha47f30e_0 -c "/bin/bash -c 'time {{streamflow_command}}'"
