#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err 
srun /opt/adw/bin/adw run -i qbioturin/workflows-postprocessing:0.1.2  -c "/bin/bash -c 'time {{streamflow_command}}'"
