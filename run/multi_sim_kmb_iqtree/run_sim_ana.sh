#!/bin/bash
sbatch <<EOT
#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=48
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4000
#SBATCH --time=24:00:00
#SBATCH --export=ALL

module purge
module load GCC/8.3.0 parallel/20190922

. /home/rawsys/matpxr/miniconda3/etc/profile.d/conda.sh
source activate R4

mkdir $1
cd $1
rm ./*

echo "staring parallel"

parallel --delay .2 -j 48 Rscript ../sim_tre.R $2 $3 {1} ::: {1..192}

#mkdir ana_out
#rm ./ana_out/*

#echo "starting analysis"

#parallel --delay .2 -j 12 Rscript ../ana_tre.R ana_out {1} ::: {1..192}

EOT
