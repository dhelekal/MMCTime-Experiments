#!/bin/bash
sbatch <<EOT
#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=48
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4000
#SBATCH --time=8:00:00
#SBATCH --export=ALL

module purge
module load GCC/8.3.0 parallel/20190922

. /home/rawsys/matpxr/miniconda3/etc/profile.d/conda.sh
source activate R4

cd $1

echo "starting analysis"

parallel --delay .2 -j 12 Rscript ../ana_tre.R ana_out {1} ::: {${2}..192}

EOT
