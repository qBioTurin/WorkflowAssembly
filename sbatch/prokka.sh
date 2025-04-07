#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err 
srun /opt/adw/bin/adw run -i staphb/prokka:1.14.6 -c "/bin/bash -c 'time {{streamflow_command}}'"
