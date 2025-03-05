#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
srun /opt/adw/bin/adw run -i staphb/prokka:1.14.6 -c "/bin/bash -c 'time {{streamflow_command}}'"
