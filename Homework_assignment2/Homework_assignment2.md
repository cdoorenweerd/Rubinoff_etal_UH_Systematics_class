# Homework assignment 2: Maximum Likelihood phylogenetics

For this homework assignment we will use some of the datasets we aligned in homework 1 to infer ML phylogenies.

## Homework assignment 2 REPORT:

Use a scientific writing style, the homework report will follow the template of a short research publication. Some quick tips to enhance your scientific writing: https://www.scitechedit.com/en-gb/helpful-resources/newsletters/502-improve-your-scientific-writing .

The report must not exceed two (2) pages with 11pt font or larger, EXCLUDING figures. Append figures after the text. Deadline to turn in is indicated in the syllabus. START EARLY with the analyses to allow time for troubleshooting, and sufficient time to ultimately write the report.

- Title, author, date
- An introduction section explaining the overlap and/or differences between the two maximum likelihood approaches (partitioned vs. non-partitioned analyses)
- A methods section explaining the analyses parameters you used for both analyses and why they are appropriate. Use the format of: "I ran analysis X to Y", e.g., "I ran a bootstrap analysis for 20,000 generations to calculate branch support". Mention the versions of the software you used (hint: look for these in the log files).
- A results and discussion section. Present the different trees that resulted from the analyses as human-readable figures. Are the trees different (are the same groups supported as monophyletic?) between your IQ-Tree results. What could cause those differences? (Hint: look at the alignment; what type of gene was used).
- Numbered figures of the resulting trees from your analyses, referenced in the text, and a screenshot of your calibrations.txt file



## 1. Infer a ML tree with IQ-Tree

1. Infer a ML tree with IQ-Tree. The input alignment files are available in the Homework2 folder on the Koa cluster, called 

```
Syndemis_all.phy
Syndemis_all_part.txt 
```

Prepare a folder with a slurm script (modify from Homework1) that will instruct IQ-Tree to infer a maximum likelihood tree. Your IQ-Tree command can look like:

Non-partitioned analysis

```
iqtree -s Syndemis_all.phy -runs 10 -B 10000 -nt AUTO -m MFP
```

What does each flag mean

-s = aligned dataset used for analysis 
-runs = number of ML runs for this analysis (more runs maybe better)
-nt = number of computer cores used in the analysis (AUTO lets computer decided)
-m = which model used in the anlayses (MPF = model finder)


slurm script to run non-partitioned analysis using the command ```sbatch```

```
#!/bin/bash
#SBATCH --job-name=Iqtree
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

source activate iqtree

iqtree -s Syndemis_all.phy -runs 10 -B 10000 -nt AUTO -m MFP
```



Partitioned analysis
```
iqtree -s Syndemis_all.phy -p Syndemis_all_part.txt -runs 10 -B 10000 -nt AUTO -m MFP
```

-p = partitioned file used in the analyses

slurm script to run partitioned analysis using the command ```sbatch```

```
#!/bin/bash
#SBATCH --job-name=Iqtree
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

source activate iqtree

iqtree -s Syndemis_all.phy -p Syndemis_all_part.txt -runs 10 -B 10000 -nt AUTO -m MFP
```



2. After this tree inference analysis finishes, transfer the resulting files back to your local computer. Include relevant details from the log file (e.g., the selected substitution model) to your report.

## 2. Create two trees for each dataset

Open the ```.contree``` file with FigTree and root the tree that IQ-Tree generated Save this tree in newick file format using the option 'File > Export Trees...' and tick the box with 'Save as currently displayed'. To create the second tree, select only the ingroup, copy (ctrl+c), open a new FigTree instance (ctrl+n) and paste (ctrl+v) - you will now have a tree of just the ingroup. Save this tree as a separate newick tree file with a sensible name.


Transfer the folder with these input files to the Mana cluster and add your run to the queue. After it finished, transfer the files back to your local computer and use FigTree to make a tree figure with confidence interval node bars, node ages (text) and a labeled x-axis that reflects time.
