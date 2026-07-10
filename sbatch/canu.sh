#!/bin/bash
#SBATCH --partition=broadwell-booked
#SBATCH -N 1 
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err  
#SBATCH --reservation=assembly
/opt/slurm/bin/srun /opt/adw/bin/adw run -i quay.io/biocontainers/canu:2.2--ha47f30e_0 -c "/bin/bash -c '{{streamflow_command}}'"
