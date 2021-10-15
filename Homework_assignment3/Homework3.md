# Homework assignment 3: Multispecies coalescent analyses

For this homework assignment you will run 4 analyses:
- ML concatenated analyses
- ML gene tree analyses
- ML species tree analyses
- Calculate gene and site concordance factors for both the concatenated and MSC tree 


## Homework assignment 3 REPORT must include:

- Title, author, date
- An introduction section explaining how the two analyses methods used in the assignment differ from each other
- A methods section explaining the analyses and setting used for this assignment.
- A results and discussion section describing the results
- Figures of the resulting trees and other figures that are relevant to the results, numbered in order as they appear in the text.

The report must not exceed two (2) pages with 11pt font or larger, excluding figures. Deadline to turn in is indicated in the syllabus.

For this homework, we are going to reanalyze some of the data from Scornavacca, C. and Galtier, N. 2017. Incomplete Lineage Sorting in Mammalian Phylogenomics. In this paper they compared supertree methods to MSC methods. Supertree methods have fallen out of favor recently so for this homework, we will infer a concatenated tree and a species tree from this data and see if there are any differences. Discuss why there are differences between the two methods and lastly which tree is the "Correct Tree". 

## 1. ML Concatenated analysis of the mammal tree of life (IQTREE)

1. Download the files from the Homework 3 folder on cluster. There will be one alignment ```mammal.fasta``` and a partition file ```mammal_part.txt``` to identify the 110 mammal genes. We have included slurm scripts which you can use to run each analysis for this home work assignement. 

2. Run slurm script ```Concatenated_analysis.slurm```

This script uses this command to run a concatenated analyses in IQTREE which tests for the best evolutionary model for each partition and calculates the most likely concatenated phylogenetic tree. It also calculates 1000 ultrafast bootstrap support values.

```
iqtree -s mammal.fasta -p mammal_part.txt --prefix Mammal_concat -bb 1000 -m MFP -nt AUTO
```

3. From the output of this analysis, open the ```Mammal_concat.treefile``` in ```figtree``` to see the best ML tree. 


## 2. ML gene tree analyses (IQTREE)

To infer a mammal MSC tree, we must first infer gene trees from each partition. To do this we must first.

1. Run slurm script ```Gene_tree_analysis.slurm```

This script uses this command below to run separate gene tree analyses for all the genes in the dataset instead of running a concatenated analysis

The ```-S``` flag signals the program to run separate gene tree analsyes.

```
iqtree -s mammal.fasta -S mammal_part.txt --prefix Mammal_loci -m MFP -nt AUTO
```

3. From the output of this analysis, the ```Mammal_loci.treefile``` should contain 110 gene trees which we will use as input in the MSC analaysis in ASTRAL. View this in ```figtree``` to see if it worked. You should have 110 gene trees in this file. 

## 3. ML species tree analysis (ASTRAL) 

To infer a mammal MSC tree, we will be using the program Astral. (https://github.com/smirarab/ASTRAL)

1. Astral is not loaded as a module in the cluster so we have included it in the homework 3 folder. The the folder ```ASTRAL``` contains the java program file is called ```astral.5.7.7.jar``` and with this we should be able to run it from directly the homework folder. 

2. Run slurm script ```Species_tree_analysis.slurm```

This script uses this command below to run a Multispecies coalecsent analyses which uses ```Mammal_loci.treefile``` as input and outputs a species tree file as ```Astral_mammal.tre```. This tree has support values which are not bootstrap values but local posterior probabilities.

```
java -jar java -jar ~/peps662_group/Homework3/ASTRAL/astral.5.7.7.jar -i Mammal_loci.treefile -o Astral_mammal.tre
```

Open the file ```Astral_mammal.tre``` in figtree to see the results. 

## 4. Gene and Site Concordance Factors

1. Gene and Site Concordance factors are a way to quantifying genealogical concordance in phylogenomic datasets. For every branch of a reference tree, gene concordance factor (gCF) is defined as the percentage of “decisive” gene trees containing that branch. While site concordance factor (sCF) is defined as the percentage of decisive alignment sites supporting a branch in the reference tree. 

To learn more about this http://www.robertlanfear.com/blog/files/concordance_factors.html

2. Run slurm script ```GCF_SCF_script.slurm```

This script uses the commands below to calculate the GCF and SCF for both concatenated tree and the species trees. 

```
#Concatenated tree gCF and sCF calculations
iqtree -t  Mammal_concat.treefile --gcf loci.treefile -s mammal.fasta --scf 100 --prefix Concat_concord -T 1

#MSC tree gCF and sCF calculations
iqtree -t  Astral_mammal.tre --gcf loci.treefile -s mammal.fasta --scf 100 --prefix Species_concord -T 1
```

This analyses will output another tree file that will add the gCF and sCF values to your concatenated and Species tree. So instead of a single value for your branch support you will have 3 values separated by forwad slashes "/". the different number correspond to the differen analyses where ultrafast boostrap/ gene concordance factors/ site concordance factors. 

open the files ```Species_concord.treefile``` and ```Concat_concord.treefile``` in figtree to see results.



