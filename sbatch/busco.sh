#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
srun /opt/adw/bin/adw run -i ezlabgva/busco:v5.8.0_cv1 -c "/bin/bash -c '{{streamflow_command}}'"
