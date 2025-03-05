#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
srun /opt/adw/bin/adw run -i teambraker/braker3:v3.0.7.6 -c "/bin/bash -c 'time {{streamflow_command}}'"
