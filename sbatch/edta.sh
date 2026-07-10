#!/bin/bash
#SBATCH --partition=broadwell-booked
#SBATCH -N 1 
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err 
#SBATCH --reservation=assembly
/opt/slurm/bin/srun /opt/adw/bin/adw run -i quay.io/biocontainers/edta:2.2.2--hdfd78af_1  -c "/bin/bash -c '{{streamflow_command}}'"
