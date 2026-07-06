#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err 
srun /opt/adw/bin/adw run -i qbioturin/assemblyevaluation:0.0.4 -c "/bin/bash -c '{{streamflow_command}}'"
