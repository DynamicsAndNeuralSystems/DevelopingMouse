#!/bin/env bash

#SBATCH --job-name=developingMouse
#SBATCH --time=01:00:00
#SBATCH --ntasks=2
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=1
#SBATCH --export=NONE

module load matlab/r2015b
srun matlab
srun startup
srun createVariance
