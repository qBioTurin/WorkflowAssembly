#!/bin/bash
#SBATCH --partition=broadwell-booked
#SBATCH -N 1 
#SBATCH --reservation=assembly
srun /opt/adw/bin/adw run -i qbioturin/assemblyevaluation:0.0.1 -c "/bin/bash -c 'time {{streamflow_command}}'"
