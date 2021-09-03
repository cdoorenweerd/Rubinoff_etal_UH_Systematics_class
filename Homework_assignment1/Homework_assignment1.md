# Homework assignment 1: Maximum likelihood and Bayesian tree inference

For this homework assignment you will run three analyses:
- An unpartitioned maximum likelihood analysis
- A partitioned maximum likelihood analysis
- A Bayesian unpartitioned analysis

Before starting the homework assignment, check that you have installed the software listed in the README.md


## Homework assignment 1 REPORT must include:

- Title, author, date
- An introduction section explaining how the three analyses methods used in the assignment differ from each other
- A methods section explaining the parameters you used and why (e.g., I ran x ultrafast bootstrap generations to ...  for each analysis. Explain which substitution model(s) you selected and why, etc)
- A results and discussion section describing the results; what is reliable, how do results differ between analyses and describe the relationships between (main groups of) taxa in the tree; which are monophyletic?
- Figures of the resulting trees and other figures that are relevant to the results, numbered in order as they appear in the text.

The report must not exceed two (2) pages with 11pt font or larger, excluding figures. Deadline to turn in is indicated in the syllabus.

## 1. Maximum likelihood with IQ-Tree, unpartitioned

1. Download the input files from the Homework 1 folder on the cluster (slurm script + alignment + partitions file + sample info file) using an SFTP file transfer program.

2. On your computer, use a text editor to browse through the files to get familiar with the formatting - can you recognize the file format from the content? Update the slurm script with your parameters and settings. Edit to your liking with your favorite text editor. Suggested parameters for IQ-Tree are shown below. Have a look at the [IQ-Tree command reference](http://www.iqtree.org/doc/Command-Reference) to see what they will do!


```
iqtree -s <your alignment file> --runs 10 -bb 5000 -nt AUTO
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


5. After your analysis finishes (you will receive an email when it does), copy the whole folder back to your local computer via SFTP. Have a look at all the result files, and use what you need for the methods section of your homework report. Open the treefile with FigTree, root the tree appropriately and show branch support values; create a figure.

## 2. Maximum likelihood with IQ-Tree, partitioned

This analysis will be like the unpartitioned IQ-Tree analysis you performed, but with an added parameter where you specify [a partitions file](http://www.iqtree.org/doc/Advanced-Tutorial) to treat each of the seven genes that make up the concatenated alignment separately during the analyses, and at the end combine the results of all into a single tree. The IQ-Tree command for this analysis can look like:

```
iqtree -s <your alignment file> --runs 10 -bb 5000 -nt AUTO -p partitions.nex
```

It is easiest if you make a new folder for this analysis, and transfer it onto the cluster to start this new analysis.


## 3. Bayesian tree inference with RevBayes

As a third analysis, you will run Bayesian tree inference with [RevBayes](https://revbayes.github.io/tutorials/intro/getting_started.html). 

1. Using a text editor, prepare a slurm script that will run RevBayes. Because a Bayesian analysis requires more resources, we want to assign those in the slurm script. Make a copy of the script you used for the IQ-Tree analysis, change the job-name, set the tasks-per-node to 8 and the --mem to 40G. This will allow the analysis to finish in approximately 14 hours. In the execution part of your slurm script, change the lines to:

```
module load bio/RevBayes/1.0.11-intel-2018.5.274-mpi
rb-mpi <myrevbayesscript.rev>
```


2. Revbayes requires a script that specifies the parameters for the analysis, instead of passing them directly with flags such as with IQ-Tree. A revbayes script to run a Bayesian analysis with two MCMC chains and a GTR+G+I model, and generate a majority-rule consensus tree, is provided in the Homework 1 files folder on the cluster, open it and read through the steps. Move the folder with all the prepared input files to ```lus_scratch``` folder on the cluster, then SSH into the cluster and start the run. Make sure all the input files (slurm script, alignment file and revbayes script) are in the same folder as where you start the run.


2. After the run finishes, copy the files over to your local computer and load the ```.log``` files into Tracer. Verify if the separate runs converged on the same optimum, and if they ran for enough generations (ESS values >>200). For further information on what to look for, see [this tutorial](https://beast.community/tracer_convergence). Include the tree and relevant Tracer graphs in your report.

