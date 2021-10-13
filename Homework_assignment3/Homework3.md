# Homework assignment 3: Multispecies coalescent analyses

For this homework assignment you will run 4 analyses:
- ML concatenated analyses
- ML gene tree analyses
- ML species tree analyses
- calculate gene and site concordance factors for the concatenated and MSC tree 


## Homework assignment 3 REPORT must include:

- Title, author, date
- An introduction section explaining how the two analyses methods used in the assignment differ from each other
- A methods section explaining ...
- A results and discussion section describing the results
- Figures of the resulting trees and other figures that are relevant to the results, numbered in order as they appear in the text.

The report must not exceed two (2) pages with 11pt font or larger, excluding figures. Deadline to turn in is indicated in the syllabus.

For this homework, we are going to reanalyze some of the data from Scornavacca, C. and Galtier, N. 2017. Incomplete Lineage Sorting in Mammalian Phylogenomics. 

## 1. ML Concatenated analysis of the mammal tree of life (IQTREE)

1. Download the input files from the Homework 3 folder on cluster. there should be only one alignment ```mammal.fasta``` and a partition file ```mammal_part.txt``` to identify the 110 mammal genes. 

2. Make a new slurm script to run a concatenated analysis on the mammal dataset. Use IQTREE to find the appropriate model for each gene (-m MPF) and generate support values using 1000 ultrafast bootstraps (-bb 1000). We use the --prefix flag to differenciate the different analyses from each other

```
iqtree -s concatenated.out -p partitions.txt --prefix Mammal_concat -bb 1000 -m MFP -nt AUTO
```

3. From the output of this analysis, open the ```Mammal_concat.treefile``` in ```figtree```


## 2. ML gene tree analyses (IQTREE)

To compare mammal MSC tree to the mammal concatenated tree tree we just inferred. We must first infer gene trees from each partition. To do this we must first

1. Make a new slurm script to run gene tree analyses

2. Use this command which uses the -S flag to run separate gene tree analyses instead of running a concatenated analysis
```
iqtree -s <your alignment file> -S <your partition file> --prefix Mammal_loci -m MFP -nt AUTO
```

3. From the output of this analysis, the ```Mammal_loci.treefile``` should contain 110 gene trees which we will use as input in the MSC analaysis in ASTRAL. 

## 3. ML species tree analysis (ASTRAL) 

1. Astral is not loaded in the cluster so you must download it and install. 

2. to install software you must first start an interactive sessioin by logging in to a compute node using this command

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
Indicating you went from a login node ```login002``` to a compute node ```node-0005```

When installing software to a cluster it is best to download and install them in the same place. This is usually a folder in your home directory 

To know you are in your home directory you can look at the command prompt and if it has a ```~```  or looks like this ```[username@node-0005 ~]$``` 

You can also use the ```cd``` command by it self and it should always send you back to your home directory.

In the UH-MANA cluster when you ```pwd``` from the home directory the output should be ```/home/username```

Once you are in the home directory make a application folder using the ```mkdir``` command then go to the apps folder

```
mkdir apps

cd apps
```

Once in the apps folder, use the git clone command to download ASTRAL to the culster

```
git clone https://github.com/smirarab/ASTRAL.git
```
This command downloads all the latest files from the ASTRAL github page.


Once downloaded go into the ASTRAL folder and load java and install the program using ```sh make.sh``` 
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

4. Gene and Site Concordance Factors

to learn more about this http://www.robertlanfear.com/blog/files/concordance_factors.html

You will need to run this analyis twice to calculate gene and site concordance factors for both the concatenated from iqtree and species tree from astral

```
iqtree -t  Mammal_concat.treefile --gcf loci.treefile -s <your alignment file> --scf 100 --prefix concord -T 1

iqtree -t  Astral_mammal.tre --gcf loci.treefile -s <your alignment file> --scf 100 --prefix concord -T 1
```

