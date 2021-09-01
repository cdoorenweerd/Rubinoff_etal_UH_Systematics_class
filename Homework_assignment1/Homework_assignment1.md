# Homework assignment 1: Maximum likelihood and Bayesian tree inference

For this homework assignment you will run three analyses:
- An unpartitioned maximum likelihood analysis
- A partitioned maximum likelihood analysis
- A Bayesian unpartitioned analysis

Before starting the homework assignment, check that you have installed the software listed in the README.md on your computer.


[] Run IQ-tree unpartitioned
[] Run IQ-tree partitioned
[] Run MrBayes unpartitioned
[] Tracer
[] FigTree



## Homework assignment 1 report must include:

- Title, author, date
- An introduction section explaining how the three analyses methods used in the assignment differ from each other
- A methods section explaining the parameters you used and why (e.g., I ran x ultrafast bootstrap generations to ...  for each analysis. Explain which substitution model(s) you selected and why, etc)
- A results and discussion section describing the results; what is reliable, how do results differ between analyses and describe the relationships between (main groups of) taxa in the tree
- Figures of the resulting trees and other figures that are relevant to the results, numbered in order as they appear in the text.

The report must not exceed two (2) pages, excluding figures. Deadline to turn in is indicated in the syllabus.

## Maximum likelihood with IQ-Tree, unpartitioned

1. Download the input files from the Homework 1 folder on the cluster (slurm + alignment + partitions file) using an SFTP file transfer program. Several alignment files are available, pick one of your liking - but use the same one for all three analyses!

2. On your computer, use a text editor to browse through the files. Select the alignment file that you will use for the analysis run. Update the slurm script with your parameters and settings. Edit to your liking with your favorite text editor. For suggested parameters for IQ-Tree see below, but have a look at the [IQ-Tree command reference](http://www.iqtree.org/doc/Command-Reference) for additional or different parameters you think are important.


```
iqtree -s <your alignment file> --runs 5 -bb 1000 -nt AUTO
```


3. When you have your input files prepared, place them in a folder and move this folder to the ```lus_scratch``` folder on the cluster using an SFTP program. 

4. Next, connect to the cluster through SSH as we have shown during the onboarding lab. Navigate to the folder that has your input files. ALWAYS START SLURM JOBS FROM WITHIN THE ```lus_scratch``` FOLDER!!! Start your analysis by adding it to the submissions queue with:

```console
[cdoorenw@login002 ~]$ sbatch <your slurm script here>
```

You can see the status of the queue on our partition with:

```console
[cdoorenw@login002 ~]$ squeue -p peps662
```


5. After your analysis finishes (you will receive an email when it does), copy the whole folder back to your local computer via SFTP. Have a look at all the result files, and use what you need for the methods section of your homework report. Open the treefile with FigTree, root the tree appropriately and show branch support values; create a figure. If needed, use the ```Tree_tip_renamer_script``` provided in this Github to modify the taxon names.

## Maximum likelihood with IQ-Tree, partitioned

0. LIke the one before, but adding a parameter

## Bayesian tree inference with MrBayes

0. run MrBayes
1. Use Tracer to see if the runs converged and if they were sufficiently long

















