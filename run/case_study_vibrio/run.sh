#!/bin/bash
sbatch <<EOT
#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4000
#SBATCH --time=12:00:00
#SBATCH --export=ALL

module purge

. /home/rawsys/matpxr/miniconda3/etc/profile.d/conda.sh
source activate R4

Rscript -e "rmarkdown::render('vibrio.rmd')" 

EOT
