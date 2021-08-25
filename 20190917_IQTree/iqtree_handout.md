# Maximum likelihood with IQtree on the UH cluster

Consider: what is ML and difference with MP and Bayesian?
What type of settings do we want to configure during a ML analysis?

Files required:
- Multisequence alignment file (e.g., in FASTA or PHYLIP format)
- Slurm script

IQ-Tree is not available as a module on the cluster, but it is available as a module in Anaconda, and Anaconda is available on the cluster.

[Anaconda (distribution):](https://www.anaconda.com/distribution/) is a package & environment manager; it installs (compiles) packages and their dependencies in a virtual environment. One time set-up.

## Set up Anaconda environment with iqtree

### 1. Connect to the cluster using SSH

```console
(base) dhcp-168-105-208-186:bash_kernel cdoorenweerd$ ssh mana
Duo two-factor login for cdoorenw

Enter a passcode or select one of the following options:

 1. Duo Push to XXX-XXX-0694
 2. Phone call to XXX-XXX-0694
 3. SMS passcodes to XXX-XXX-0694

Passcode or option (1-3): 1

Pushed a login request to your device...
Success. Logging you in...
========================================================================
Unauthorized access is prohibited by law in accordance with Chapter 708,
Hawaii Revised Statutes; all use is subject to University of Hawaii
Executive Policy E2.210.(http://go.hawaii.edu/JYj)
========================================================================

===================== ANNOUNCEMENTS=====================================

New cluster information: https://www.hawaii.edu/its/ci/xcat
FAQ: http://go.hawaii.edu/jdG
Latest HPC-101 (Onboarding) slides: http://go.hawaii.edu/wL

------------------------------------------------------------------------

Up-to-date sample SLURM scripts: /mnt/config/examples
The modules list has hidden modules.
To view the full module list: module --show_hidden av

========================================================================

========================================================================
Hostname: login002 
Date    : Thu Sep 12 20:42:33 UTC 2019
Uptime :  20:42:33 up 16:19, 12 users,  load average: 0.15, 0.19, 0.14

========================================================================

============================== USAGE ==================================

PATH                                    QUOTA     USED      PCT USED
/mnt/group/nfs_fs01/pep662_class        50G       512K      1%
/home/cdoorenw                          50G       241M      1%
/mnt/scratch/nfs_fs02/cdoorenw          5.0T      896K      1%

========================================================================
```

### 2. Next, start an interactive session on the ```pep662``` or ```sandbox``` node

```console
[cdoorenw@login002 ~]$ srun -I30 --partition pep662 --account pep662_f2021 --cores 1 --mem=4gb --time 0-04:00:00 --pty /bin/bash
```

or

```console
[cdoorenw@login002 ~]$ srun -I30 --partition sandbox --cores 1 --mem=4gb --time 0-04:00:00 --pty /bin/bash
```

Note how the @ address changes from ```[cdoorenw@login002 ~]$ ``` to something like: ```[cdoorenw@node-0040 ~]$ ``` to tell you that you are now on a compute node.

### 3. Load the Anaconda module

Check which cluster modules are currently loaded with:

```console
[cdoorenw@node-0040 ~]$ module list
```
None are currently loaded. Go ahead and load the Anaconda module with:

```console
[cdoorenw@node-0040 ~]$ module load lang/Anaconda3/5.1.0
[cdoorenw@node-0040 ~]$ module list

Currently Loaded Modules:
  1) lang/Anaconda3/5.1.0
```

### 4. Create an Anaconda environment with IQ-TREE

[Conda environments documentation](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html)

See which environments are already installed:
```console
[cdoorenw@node-0040 ~]$ conda info --envs
```

Should be just the base. Now create a new environment [with IQ-tree](https://anaconda.org/bioconda/iqtree)

```console
[cdoorenw@node-0040 ~]$ conda create --name iqtenv -c bioconda iqtree
```

Check the list again:

```console
[cdoorenw@node-0040 ~]$ conda info --envs
# conda environments:
#
iqtenv                   /home/cdoorenw/.conda/envs/iqtenv
base                  *  /opt/apps/software/lang/Anaconda3/5.1.0
```

All set! Exit the interactive srun with ```exit```

# IQ-Tree homework assignment

Now that our environment is set-up, we can prepare the input files. An example slurm script (YOU WILL NEED TO MODIFY THIS) and several aligment files for you to choose from are provided. Use a text-editor to verify and prepare your multisequence alignment file and slurm script with the appropriate IQ-Tree parameters to run. Use sftp (Filezilla or Cyberduck) to move the files to the cluster and start a run.

ALWAYS START SLURM JOBS FROM WITHIN THE ```lus_scratch``` FOLDER!!!

Connect to the cluster using SSH. Navigate to the ```lus_scratch``` subfolder that has the input files and start a batch submission

```console
[cdoorenw@login002 ~]$ sbatch <slurm script>
```

You can see the status of the queue on our partition with:

```console
[cdoorenw@login002 ~]$ squeue -p pep662
[cdoorenw@login002 ~]$ squeue -u pep662_f2021
```

## Homework assignment report

A maximum of two-pages report must cover:

- Explain why you used this analysis method ("because you were told to do so" gives 0 points)
- Explain how you decided on the settings (paramters) that you chose and clearly write which ones you used.
- Figure the result(s) (tree(s))
- Briefly describe the results and what they mean


