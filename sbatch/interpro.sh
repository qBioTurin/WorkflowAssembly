#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err 
srun /opt/adw/bin/adw run -i qbioturin/interproscan:5.73-104.0.2.2 -v /beegfs/home/scontald/interproscan-5.73-104.0/data:/opt/interproscan/data -c "/bin/bash -c 'time {{streamflow_command}}'"
