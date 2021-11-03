# Homework assignment 3: Multispecies coalescent analyses

For this homework, we are going to reanalyze some of the data from Scornavacca, C. and Galtier, N. 2017. Incomplete Lineage Sorting in Mammalian Phylogenomics. In this paper they compared supertree methods to multi-species coalescent (MSC) methods. Supertree methods have fallen out of favor recently so for this homework, we will infer a concatenated tree and a species tree from this data and see if there are any differences and decide upon which is the "Correct Tree" given the data we have. 

You will run three analyses:
- Maximum likelihood (ML) concatenated analysis. This is the type of ML analysis you have used in homework 1 and 2 as well.
- ML gene tree analysis
- ML species tree analysis
- Calculate gene and site concordance factors for concatenated tree and sepecies tree


## Homework assignment 3 REPORT:

This assignment is worth 35 points!

Use a scientific writing style, the homework report will follow the template of a short research publication. Some quick tips to enhance your scientific writing: https://www.scitechedit.com/en-gb/helpful-resources/newsletters/502-improve-your-scientific-writing .

The report must not exceed two (2) pages with 11pt font or larger, EXCLUDING figures. Append figures after the text. Deadline to turn in is indicated in the syllabus. START EARLY with the analyses to allow time for troubleshooting, and sufficient time to ultimately write the report.


- Title, author, date
- An introduction section. Cover the following topics briefly: (1) what is a gene tree and how is it different from a species tree, (2) how is a concatenated analysis different from a gene tree analysis and (3) why is it relevant to do a multi-species coalescent approach, especially with genomic data (hint: can different genes have different evolutionary trajectories/histories?)
- A methods section explaining the analyses and settings used for each section of the assignment: creating a concatenated tree, generating gene trees and performing a multi-species coalescent analysis on the gene trees. Include version numbers of the software. 
- A results and discussion section describing the results. Cover: (1) are there differences in the topology between the concatenated and the MSC analysis (be specific), (2) are there (and if so, where) differences in the support values for the branches. Discuss what could cause any difference in support values and argue which tree you feel is more reliable and closer to the 'true' tree.
- Figures of the resulting trees and other figures that are relevant to the results, numbered in order as they appear in the text.

The report must not exceed two (2) pages with 11pt font or larger, excluding figures. Deadline to turn in is indicated in the syllabus.

## 1. Move files to working directory

1. All files needed to run analyses for this homework are in the peps homework3 folder. You will need to move the contents of this folder to a working directory in the nfs_scratch

```
cp -r ~/peps662_group/Homework3 ~/nfs_scratch/Homework3
```

the -r flag tells the cluster copy all files and folders 

2. once finished go to the working directory

```
cd ~/nfs_scratch/Homework3
```


## 1. ML Concatenated analysis of the mammal tree of life (IQ-TREE)

1. Download the files from the Homework 3 folder on cluster to your local computer. There will be one alignment file ```mammal.fasta``` and a partition file ```mammal_part.txt``` to identify the 110 mammal genes in the concatenated alignment. We have also included slurm scripts which you can use to run each analysis for this home work assignment. 

2. Use sbatch on the slurm script ```Concatenated_analysis.slurm``` to run the analysis on the cluster. Make sure to change the email address on the slurm scirpt to your email address. Login to the cluster and start the analysis by adding the slurm script to the queue by using the command below. 


```
sbatch Concatenated_analysis.slurm
```

The slurm script uses this command to run a concatenated analyses in IQ-TREE which tests for the best evolutionary model for each partition and calculates the most likely concatenated phylogenetic tree. It also calculates 1000 ultrafast bootstrap support values.

```
iqtree -s mammal.fasta -p mammal_part.txt --prefix Mammal_concat -bb 1000 -m MFP -nt AUTO
```

3. From the output of this analysis, open the ```Mammal_concat.treefile``` in ```figtree``` to see the best ML tree. Root the tree using the taxon ```Ornithorhynchus``` for all analyses.  Ensure the text is readable, show the branch support values on the branches and include the tree in your report.


## 2. ML gene tree analyses (IQ-TREE)

1. To infer a mammal multi-species coalescent tree, we must first infer a gene tree for each gene in the partitioned alignment. Luckily, IQ-tree makes that really easy. Use sbatch on the slurm script ```Gene_tree_analysis.slurm``` to run the analysis on the cluster. This analysis requires the ```mammal.fasta``` alignment and the ```mammal_part.txt``` partition files

use this command to run the script

```
sbatch Gene_tree_analysis.slurm
```

This script uses this command below to run separate gene tree analyses for all the genes in the dataset instead of running a concatenated analysis. The ```-S``` flag signals the program to run separate gene tree analsyes, where it uses the partition file to identify where the genes are in the alignment.

```
iqtree -s mammal.fasta -S mammal_part.txt --prefix Mammal_loci -m MFP -nt AUTO
```

2. From the output of this analysis, the file ```Mammal_loci.treefile``` should contain 110 gene trees which we will use as input in the MSC analaysis in ASTRAL. To check if he resulting file contains 110 trees, open the ```.treefile``` in ```figtree``` to see if it worked. If it did, the left and right arrow buttons at the top will be active and you can cycle through all the trees. You do not have to include these trees in the report, it is only used as input for part 3.

## 3. MSC species tree analysis (ASTRAL) 

The program Astral [https://github.com/smirarab/ASTRAL] can use the gene trees that we generated in step 2 to create a multi-species coalescent species tree, which we will do next.

1. Astral is not available as a module in the cluster so we have included it in the Homework 3 folder. Because it is a JAVA based program, you do not have to install it like we did with IQ-tree and Anaconda. Instead, the folder ```ASTRAL``` contains the java program file, called ```astral.5.7.7.jar```, and with this we can run it directly from the homework folder. 

2. Prepare a folder with the ```Mammal_loci.treefile``` that you generated at step 2, and include the slurm script ```Species_tree_analysis.slurm``` that is available in the Homework3 folder on the cluster. Start the analysis by adding the slurm script to the queue. 

```
sbatch Species_tree_analysis.slurm
```

This slurm script uses the command below to run a Multispecies coalecsent analyses which uses ```Mammal_loci.treefile``` as input and outputs a species tree file as ```Astral_mammal.tre```. This tree has support values which are not bootstrap values but local posterior probabilities. Local posterior probablility are the probability this branch is the true branch given the set of gene trees

```
java -jar java -jar ~/peps662_group/Homework3/ASTRAL/astral.5.7.7.jar -i Mammal_loci.treefile -o Astral_mammal.tre
```

3. Open the file ```Astral_mammal.tre``` in ```figtree``` to see the results. Ensure the text is readable, show the branch support values on the branches and include the tree in your report.


## 4. Calculate Gene and Site concordance factors for both trees  (IQ-TREE)

We will calculate two measures for quantifying the genealogical concordance in phylogenomic datasets: the gene concordance factor (gCF) and the site concordance factor (sCF). For every branch of a reference tree, gCF is defined as the percentage of “decisive” gene trees containing that branch. sCF is defined as the percentage of decisive alignment sites supporting a branch in the reference tree. sCF is a novel measure that is particularly useful when individual gene alignments are relatively uninformative, such that gene trees are uncertain. gCF and sCF complement classical measures of branch support (e.g. bootstrap) in phylogenetics by providing a full description of underlying disagreement among loci and sites.

These measures are calculated in IQ-TREE, with these two commands 

```
iqtree -t Mammal_concat.treefile --gcf Mammal_loci.treefile -s mammal.fasta --scf 100 --prefix Mammal_concat_CF -T 1
```

```
iqtree -t Astral_mammal.tre --gcf Mammal_loci.treefile -s mammal.fasta --scf 100 --prefix Mammal_MSC_CF -T 1
```

-t flag indicates what tree to use to caculate these statistics

--gcf flag indicates which gene treese to use to calculate gCF

--scf flag which alignment to use to calculate sCF

--prefix indicates how to lable the output files

--T indicates how many cores (CPUs) to use 


The output trees will contain 3 branch support values per branch.

(original branch support)/gCF/sCF

open ```Mammal_MSC_CF.cf.tree``` and ```Mammal_concat_CF.cf.tree``` to see results from the MSC (astral) analysis and the concatenated analysis. 

