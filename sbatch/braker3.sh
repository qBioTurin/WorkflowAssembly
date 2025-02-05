#!/bin/bash
#SBATCH --partition=broadwell-booked
#SBATCH -N 1 
#SBATCH --reservation=assembly
srun /opt/adw/bin/adw run -i teambraker/braker3:v3.0.7.6 -c "/bin/bash -c 'time {{streamflow_command}}'"
