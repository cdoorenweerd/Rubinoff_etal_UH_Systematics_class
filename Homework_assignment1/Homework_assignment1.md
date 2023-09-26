# Homework assignment 1: Sequence alignment and file conversions

For this homework assignment you will align and concatenate 3 datasets:
- Hawaiian Hyles dataset
- Nepticulidae dataset
- Syndemis dataset

Before starting the homework assignment, check that you have installed the software listed in the README.md and Software_installation_anaconda.md 


## Homework assignment 1 REPORT must include:

- Title, author, date
- A slurm script used to align the Nepliculidae dataset and the resulting alignment in phylip format.
- A slurm script used to align the Hawaiian Hyles dataset and concatenated in nexus format with a partition file.
- A slurm script used to align the Syndemis dataset and concatenated in fasta format with a partition file.

Deadline to turn in is indicated in the syllabus. October 3 


Example slurm script for homework


```
#!/bin/bash
#SBATCH --job-name=sequence_alignment
#SBATCH --partition=shared
## 3 day max run time for public partitions, except 4 hour max runtime for the sandbox partition
#SBATCH --time=1-00:00:0 ## time format is DD-HH:MM:SS
## task-per-node x cpus-per-task should not typically exceed core count on an individual node
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=6G ## max amount of memory per node you require
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

muscle -align Hypo_EOG7BGV00.fasta -output Hypo_EOG7BGV00_aligned.fasta

muscle -align Hypo_EOG7D2RTJ.fasta -output Hypo_EOG7D2RTJ_aligned.fasta

muscle -align Hypo_EOG7D5N1M.fasta -output Hypo_EOG7D5N1M_aligned.fasta

muscle -align Hypo_EOG7DCCK3.fasta -output Hypo_EOG7DCCK3_aligned.fasta



AMAS.py concat -i Hypo_*_aligned.fasta -f fasta -d dna 

mv concatenated.out Hypo_all_aligned.fasta
mv partition.txt  Hypo_all_partition.txt


```
