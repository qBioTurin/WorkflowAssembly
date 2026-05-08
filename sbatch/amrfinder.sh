#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err 
#SBATCH --reservation=assembly
srun /opt/adw/bin/adw run -i quay.io/staphb/ncbi-amrfinderplus:4.2.7-2026-03-24.1 -c "/bin/bash -c '{{streamflow_command}}'"
