#!/bin/bash
#SBATCH --job-name=Alignment
#SBATCH --partition=shared
## 3 day max run time for public partitions, except 4 hour max runtime for the sandbox partition
#SBATCH --time=1-00:00:0 ## time format is DD-HH:MM:SS
## task-per-node x cpus-per-task should not typically exceed core count on an individual node
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=6 ## max amount of memory per node you require
##SBATCH --core-spec=0 ## Uncomment to allow jobs to request all cores on a node
#SBATCH --error=err-%A.err ## %A - filled with jobid
#SBATCH --output=out-%A.out ## %A - filled with jobid
## Useful for remote notification
#SBATCH --mail-type=BEGIN,END,FAIL,REQUEUE,TIME_LIMIT_80
#SBATCH --mail-user=youremail@hawaii.edu
## All options and environment variables found on schedMD site: http://slurm.schedmd.com/sbatch.html
source ~/.bash_profile

module load lang/Anaconda3/2023.03-1

source activate sequence_alignment

muscle -align input.fa -output aln.afa


mafft infile.fasta > outfile.fasta


AMAS.py concat -i Hypo_* -f fasta -d dna
