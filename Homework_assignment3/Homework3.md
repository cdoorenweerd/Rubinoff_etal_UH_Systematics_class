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

1. Download the input files from the Homework 3 folder on cluster. there should be only one alignment ```mammal.fasta``` and a partition file ```mammal_part.txt``` to identify the 110 mammal genes. 

2. Make a new slurm script to run a concatenated analysis on the mammal dataset. Use IQTREE to find the appropriate model for each gene (-m MPF) and generate support values using 1000 ultrafast bootstraps (-bb 1000). We use the --prefix flag to differenciate the different analyses from each other

```
iqtree -s mammal.fasta -p mammal_part.txt --prefix Mammal_concat -bb 1000 -m MFP -nt AUTO
```

3. From the output of this analysis, open the ```Mammal_concat.treefile``` in ```figtree```


## 2. ML gene tree analyses (IQTREE)

To compare mammal MSC tree to the mammal concatenated tree tree we just inferred. We must first infer gene trees from each partition. To do this we must first

1. Make a new slurm script to run gene tree analyses

2. Use this command which uses the -S flag to run separate gene tree analyses instead of running a concatenated analysis
```
iqtree -s mammal.fasta -p mammal_part.txt --prefix Mammal_loci -m MFP -nt AUTO
```

3. From the output of this analysis, the ```Mammal_loci.treefile``` should contain 110 gene trees which we will use as input in the MSC analaysis in ASTRAL. View this in ```figtree``` to see if it worked.

## 3. ML species tree analysis (ASTRAL) 

1. Astral is not loaded in the cluster so you must download it and install. 

2. To download and install software you must first start an interactive session on the cluster by logging in to a compute node using this command

```
srun -I30 -p sandbox -N 1 -c 1 --mem=6G -t 0-01:00:00 --pty /bin/bash
```

once logged in the the command prompt will go from

```
[username@login002 ~]$
```
to
```
[username@node-0005 ~]$
```
where the ```username``` should be your UH username/email. 

This change indicates you went from a login node ```login002``` to a compute node ```node-0005```

When installing software to a cluster, it is best to download all software and install them in the same place. This is usually a folder in your home directory 

To know you are in your home directory you can look at the command prompt and if it has a ```~```  or looks like this 

```
[username@node-0005 ~]$
``` 

You can also use the ```cd``` command by itself and it should always send you back to your home directory.

```
cd
```

In the UH-MANA cluster, when you use ```pwd``` command from the home directory the output should be ```/home/username```

Once you are in the home directory make a new folder using the ```mkdir``` command then go to this folder

```
mkdir apps

cd apps
```

Once in the apps folder, use the git clone command to download ASTRAL to the culster

```
git clone https://github.com/smirarab/ASTRAL.git
```
This command can only be used in an interactive session on a compute node. It will download all the latest files from the ASTRAL github page. (https://github.com/smirarab/ASTRAL)


Once downloaded go into the ASTRAL folder and load java and install the program using ```sh make.sh``` command.

You will also have to load the java module for this to work.

```
cd ASTRAL/
module load lang/Java/1.8.0_241
sh make.sh
```

Once it is finished astral is installed and there should be a file called ```astral.5.7.7.jar``` which is the installed java program.   

Now we can run astral to make a MSC tree.

go back to the folder containing your output files from iqtree.

To run Astral you must run this command using the Mammal gene trees as input and outputting ad species tree.

```
java -jar ~/Apps/ASTRAL/astral.5.7.7.jar -i Mammal_loci.treefile -o Astral_mammal.tre
```

## 4. Gene and Site Concordance Factors

Gene and Site Concordance factors are a way to quantifying genealogical concordance in phylogenomic datasets. For every branch of a reference tree, gene concordance factor (gCF) is defined as the percentage of “decisive” gene trees containing that branch. While site concordance factor (sCF) is defined as the percentage of decisive alignment sites supporting a branch in the reference tree. 

To learn more about this http://www.robertlanfear.com/blog/files/concordance_factors.html

You will need to run this analyis twice to calculate gene and site concordance factors for both the concatenated from iqtree and species tree from astral

```
#Concatenated tree gCF and sCF calculations
iqtree -t  Mammal_concat.treefile --gcf loci.treefile -s <your alignment file> --scf 100 --prefix concord -T 1

#MSC tree gCF and sCF calculations
iqtree -t  Astral_mammal.tre --gcf loci.treefile -s <your alignment file> --scf 100 --prefix concord -T 1
```

