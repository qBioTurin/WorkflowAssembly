#!/bin/bash
#SBATCH --partition=broadwell-booked
#SBATCH -N 1 
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err
#SBATCH --reservation=assembly 
/opt/slurm/bin/srun /opt/adw/bin/adw run -i qbioturin/antismash:8.0.4.1 -c "/bin/bash -c '{{streamflow_command}}'"
