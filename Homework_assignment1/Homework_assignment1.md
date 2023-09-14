# Installing programs with Anaconda on the UH Koa cluster

Many programs are not available as a module on the cluster, but we can install them in an Anaconda environment.

[Anaconda (distribution):](https://www.anaconda.com/distribution/) is a package & environment manager; it installs (compiles) packages and their dependencies in a virtual environment. One time set-up.

## Set up an Anaconda environment 

### 1. Connect to the cluster using SSH or On Demand (https://koa.its.hawaii.edu/pun/sys/dashboard/).

```console
Duo two-factor login for cdoorenw

Enter a passcode or select one of the following options:

 1. Duo Push to XXX-XXX-0694
 2. Phone call to XXX-XXX-0694
 3. SMS passcodes to XXX-XXX-0694

Passcode or option (1-3): 1

Pushed a login request to your device...
Success. Logging you in...
============================================ LOGIN NODE INFO ============================================
Hostname: login002 
Date    : Thu Sep  2 00:49:49 UTC 2021
Uptime :  00:49:49 up  2:30,  6 users,  load average: 0.11, 0.06, 0.05
=========================================================================================================

=========================================================================================================
                                 ##     ##    ###    ##    ##    ###                                     
                                 ###   ###   ## ##   ###   ##   ## ##                                    
                                 #### ####  ##   ##  ####  ##  ##   ##                                   
                                 ## ### ## ##     ## ## ## ## ##     ##                                  
                                 ##     ## ######### ##  #### #########                                  
                                 ##     ## ##     ## ##   ### ##     ##                                  
                                 ##     ## ##     ## ##    ## ##     ##                                  
=========================================================================================================
 Unauthorized access is prohibited by law in accordance with Chapter 708 of the Hawaii Revised Statutes  
     all use is subject to University of Hawaii Executive Policy EP 2.210.(http://go.hawaii.edu/JYj)     
=========================================================================================================

                  Mana is also subject to the additional University of Hawaii policies                   
_________________________________________________________________________________________________________
Executive Policy EP 2.214: Data Classification & Security Guidelines (http://go.hawaii.edu/FLG)
Executive Policy EP 2.215: Data Governance Policy (http://go.hawaii.edu/GLa)
=========================================================================================================

=========================================  INFORMATIONAL LINKS  =========================================
Data Governance: https://www.hawaii.edu/uhdatagov/
UH Information Security: https://www.hawaii.edu/infosec/
Office of Research Compliance https://researchcompliance.hawaii.edu/

Mana General Information: https://datascience.hawaii.edu/hpc/
Mana FAQ, tutorials and details: http://go.hawaii.edu/JLA
Latest HPC-101 (Onboarding) slides: http://go.hawaii.edu/wL
=========================================================================================================

================================================  HINTS  ================================================
Up-to-date sample SLURM scripts: /mnt/config/examples
The modules list has hidden modules.
To view the full module list: module --show_hidden av
Mana FAQ, tutorials and details: http://go.hawaii.edu/JLA
=========================================================================================================
                                                                                                         
========================================== YOUR CUIRRENT USAGE ==========================================
PATH                                     SYMLINK        QUOTA  USED(%)      INODE QUOTA  INODE USED
_______________________________________  _____________  _____  ___________  ___________  __________
/home/cdoorenw                                          50G    5.8G (12%)   -            -
/mnt/group/nfs_fs01/class_peps662        peps662_group  50G    128K (1%)    -            -
/mnt/scratch/lustre_01/scratch/cdoorenw  lus_scratch    5T     285.3M (0%)  3072000      38
/mnt/scratch/nfs_fs02/cdoorenw           nfs_fs02       5.0T   256K (1%)    -            -
/mnt/scratch/nfs_fs02/cdoorenw           nfs_scratch    5.0T   256K (1%)    -            -
=========================================================================================================
```

### 2. Next, start an interactive session on the ```sandbox``` partition

```console
srun -I30 -p sandbox -N 1 -c 1 --mem=6G -t 0-04:00:00 --pty /bin/bash
```


Note how the @ address changes from ```[cdoorenw@login002 ~]$ ``` to something like: `````` to tell you that you are now on a compute node.

### 3. Load the Anaconda module

Check which cluster modules are currently loaded with:

```console
module list
```
None are currently loaded. Go ahead and load the Anaconda module with:

```console
module load lang/Anaconda3/2023.03-1
module list

Currently Loaded Modules:
  1) lang/Anaconda3/2023.03-1
```

### 4. Create an Anaconda environment

[Conda environments documentation](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html)

See which environments are already installed:
```console
conda env list
```

Should be just the base. Now create a new environment [with IQ-tree](https://anaconda.org/bioconda/iqtree)

```console
conda create --name sequence_alignment 
```

Check the list again:

```console
conda env list
# conda environments:
#
sequence_alignment        /home/cdoorenw/.conda/envs/sequence_alignment
base                  *  /opt/apps/software/lang/Anaconda3/5.1.0
```

### 4. Create an Anaconda environment

Make sure you are in the ```sequence_alignment``` environment

```console
source activate sequence_alignment
```
search google for commands to install software you need.

we will install t-coffee muscle and mafft.

This will install the software one at a time.
```console
conda install -c bioconda muscle
conda install -c bioconda mafft
```

Or we can install them all at once
```console
conda install -c bioconda muscle mafft
```

We will also want to install AMAS which allows easy file conversions as well as concatenation and summary statistics for sequence datasets

To install this software you would use this command
```console
conda install -c bioconda amas
```

to test if the installation went well

call the help flag for all software

```console
muscle -h
mafft -h 
AMAS.py -h 
```

To align a sequence file with muscle in command line

```
muscle -align input.fa -output aln.afa
```
Where you use the -align flag to give muscle your unalign file and you tell it to output your aligned data as aln.afa with the -output flag

to align a sequence file with mafft in command line

```
mafft infile.fasta > outfile.fasta
```

The syntax is diffent with mafft. After you type in the mafft command you give it your input file and tell it to output and aligned outputfile with the greater than (>) sign.


Once each gene has been aligned we can concatenated it togeather into a single file and a partition file. 

The partition file tells the analysis software where each gene is in the large alignment.

to do this we use AMAS.py 

AMAS.py can do a number of things

The AMAS commands are:
  concat      Concatenate input alignments
  convert     Convert to other file format
  replicate   Create replicate data sets for phylogenetic jackknife
  split       Split alignment according to a partitions file
  summary     Write alignment summary
  remove      Remove taxa from alignment
  translate   Translate DNA alignment into protein alignment
  trim        Remove columns from alignment
  
  
But we will mainly use it to create concatenated files today 


```console
AMAS.py concat -h

Concatenate input alignments
options:
  -h, --help            show this help message and exit
  -p CONCAT_PART, --concat-part CONCAT_PART
                        File name for the concatenated alignment partitions. Default: 'partitions.txt'
  -t CONCAT_OUT, --concat-out CONCAT_OUT
                        File name for the concatenated alignment. Default: 'concatenated.out'
  -u {fasta,phylip,nexus,phylip-int,nexus-int}, --out-format {fasta,phylip,nexus,phylip-int,nexus-int}
                        File format for the output alignment. Default: fasta
  -y {nexus,raxml,unspecified}, --part-format {nexus,raxml,unspecified}
                        Format of the partitions file. Default: 'unspecified'
  -e, --check-align     Check if input sequences are aligned. Default: no check
  -c CORES, --cores CORES
                        Number of cores used. Default: 1
required arguments:
  -i IN_FILES [IN_FILES ...], --in-files IN_FILES [IN_FILES ...]
                        Alignment files to be taken as input. You can specify multiple files using wildcards (e.g. --in-files *fasta)
  -f {fasta,phylip,nexus,phylip-int,nexus-int}, --in-format {fasta,phylip,nexus,phylip-int,nexus-int}
                        The format of input alignment
  -d {aa,dna}, --data-type {aa,dna}
                        Type of data
``` 


to do this we will use this command

```console
AMAS.py concat -i Hypo_* -f fasta -d dna
```

This will output a concatenated.out file which will be all your genes put togeather and a partition.txt file which is the partiton file. 

With this we can start making trees!

All set! Exit the interactive srun with ```exit```