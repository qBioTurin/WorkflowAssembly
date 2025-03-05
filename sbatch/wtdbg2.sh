#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
srun /opt/adw/bin/adw run -i quay.io/staphb/wtdbg2:2.5   -c "/bin/bash -c 'time {{streamflow_command}}'"
