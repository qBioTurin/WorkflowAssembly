#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
#SBATCH --reservation=assembly
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err 
#SBATCH --reservation=assembly
srun /opt/adw/bin/adw run -i ezlabgva/busco:v5.8.0_cv1 -c "/bin/bash -c '{{streamflow_command}}'"
