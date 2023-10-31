#!/bin/bash
#SBATCH --job-name=revbayes
#SBATCH --partition=shared
## 3 day max run time for public partitions, except 4 hour max runtime for the sandbox partition
#SBATCH --time=3-00:00:0 ## time format is DD-HH:MM:SS
## task-per-node x cpus-per-task should not typically exceed core count on an individual node
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=19
#SBATCH --mem=120G  ## max amount of memory per node you require
#SBATCH --core-spec=0 ## Uncomment to allow jobs to request all cores on a node
#SBATCH --error=error/err-%A.err ## %A - filled with jobid
#SBATCH --output=out/out-%A.out ## %A - filled with jobid
## Useful for remote notification
#SBATCH --mail-type=BEGIN,END,FAIL,REQUEUE,TIME_LIMIT_80
## make sure to change to your email adress
#SBATCH --mail-user=youremail@hawaii.edu
## All options and environment variables found on schedMD site: http://slurm.schedmd.com/sbatch.html
source ~/.bash_profile

module load lang/Anaconda3/2023.03-1

source activate revbayes

rb -b Hyles_revbayes_GTR.rev