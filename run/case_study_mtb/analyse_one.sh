#!/bin/bash
sbatch <<EOT
#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=4000
#SBATCH --time=03:00:00
#SBATCH --export=ALL

module purge

. /home/rawsys/matpxr/miniconda3/etc/profile.d/conda.sh
source activate R4

Rscript analyse_one.R $1 $2 $3

EOT
