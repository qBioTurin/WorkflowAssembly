#!/bin/bash
#SBATCH --partition=broadwell-booked
#SBATCH -N 1 
#SBATCH --reservation=assembly
srun /opt/adw/bin/adw run -i ezlabgva/busco:v5.8.0_cv1 -c "/bin/bash -c 'time {{streamflow_command}}'"
