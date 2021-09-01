# Homework assignment 1: Maximum likelihood and Bayesian tree inference

For this homework assignment you will run three analyses:
- An unpartitioned maximum likelihood analysis
- A partitioned maximum likelihood analysis
- A Bayesian unpartitioned analysis

[] Run IQ-tree
[] Run IQ-tree partitioned
[] Run MrBayes unpartioned
[] Tracer
[] FigTree



## Homework assignment 1 report must include:

- Title, author, date
- A section explaining how the three analyses methods differ from each other
- A section explaining the parameters you used and why (e.g., I ran x ultrafast bootstrap generations to ...  for each analysis. Explain which substitution model(s) you selected and why, etc)
- A section describing the results; what is reliable, how do results differ between analyses and describe the relationships between (main groups of) taxa in the tree
- Figures of the resulting trees and other figures that are relevant to the results, numbered 

Max. 2 pages, excluding figures

## Maximum likelihood with IQ-Tree, unpartitioned

0. Download the input files from the Homework 1 folder on the cluster (slurm + alignment + partitions file) using an SFTP file transfer program
0. Edit to your liking with your favorite text editor

Suggested parameters for IQ-Tree:

```
iqtree -s 20210813_COI_1493.fas --runs 5 -bb 1000 -nt AUTO
```

But see the http://www.iqtree.org/doc/Command-Reference for additional or different parameters you think are important.

1. Connect to the cluster through SSH
2. Move input files into a folder where you will run the analysis

ALWAYS START SLURM JOBS FROM WITHIN THE ```lus_scratch``` FOLDER!!! Connect to the cluster using SSH. Navigate to the ```lus_scratch``` subfolder that has the input files and start a batch submission:

```console
[cdoorenw@login002 ~]$ sbatch <slurm script>
```

You can see the status of the queue on our partition with:

```console
[cdoorenw@login002 ~]$ squeue -p peps662
```


3. After the analysis finishes: move files to local computer; study the files created by the program and use what you need to write into the report. Open the treefile with FigTree, root the tree appropriately and show branch support values; create a figure. 

## Maximum likelihood with IQ-Tree, partitioned

0. LIke the one before, but adding a parameter

## Bayesian tree inference with MrBayes

0. run MrBayes
1. Use Tracer to see if the runs converged and if they were sufficiently long

















