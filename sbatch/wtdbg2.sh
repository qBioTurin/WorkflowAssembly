#!/bin/bash
#SBATCH --partition=broadwell-booked
#SBATCH -N 1 
#SBATCH --reservation=assembly
srun /opt/adw/bin/adw run -i quay.io/staphb/wtdbg2:2.5   -c "/bin/bash -c 'time {{streamflow_command}}'"
