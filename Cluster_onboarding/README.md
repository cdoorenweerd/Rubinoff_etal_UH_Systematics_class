# Cluster Onboarding

## KOA and MANA cluster information https://datascience.hawaii.edu/hpc/

## Latest HPC-101 (Onboarding) slides: http://go.hawaii.edu/wL

There are two ways to access the KOA cluster

Commandline (terminal [MAC] or putty [PC])

Web Browser https://koa.its.hawaii.edu/pun/sys/dashboard/


## Command line interface (CLI) vs Graphical User Interface (GUI)

In command line interface (CLI) you type commands to instruct the computer what to do. If you are completely new to this, try this introductory video: https://www.youtube.com/watch?v=5XgBd6rjuDQ&t=228s

In a GUI (graphical user interface) you click buttons to instruct the computer what to do. CLI saves programmers from having to create a graphical interface, so it is much easier for the programmer and most data science programs will be programmed this way.

## Basic Linux Commands 

- `nano`/`vim` = a command line text editor to change the contents of a file
- `pwd` = command to find out the path of the current working directory
- `cd` = command to change directory 
- `ls` = command to list contents of a directory
- `cat` = command to concatenate two file together (can also be used to view contents of a file)
- `cp` = command to copy a file
- `mv` = command to move a file (can be used to rename file)
- `mkdir` = command to make a directory
- `rm` = command to delete a file or directory

## Introduction to Unix
https://bioinformaticsworkbook.org/Appendix/Unix/unix-basics-1.html#gsc.tab=0

## Free online computational training
https://scinet.usda.gov/training/free-online-training


# In class excersise 

## CLI basics
Log in to the cluster

go to the class_peps662 folder

copy all the files in File_formats folder to the lustre folder

view all the files to see differences between file formats

copy all the files to you local computer

view them in a text editor



## slurm example

Go to folder examples/slurm/non_mpi in home directory

```
#!/bin/bash
#SBATCH --job-name=example
#SBATCH --partition=sandbox
## 3 day max run time for public partitions, except 4 hour max runtime for the sandbox partition
#SBATCH --time=0-01:00:00 ## time format is DD-HH:MM:SS
## task-per-node x cpus-per-task should not typically exceed core count on an individual node
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=6400 ## max amount of memory per node you require
##SBATCH --core-spec=0 ## Uncomment to allow jobs to request all cores on a node    
#SBATCH --error=hello-%A.err ## %A - filled with jobid
#SBATCH --output=hello-%A.out ## %A - filled with jobid
## Useful for remote notification
##SBATCH --mail-type=BEGIN,END,FAIL,REQUEUE,TIME_LIMIT_80
##SBATCH --mail-user=user@test.org
## All options and environment variables found on schedMD site: http://slurm.schedmd.com/sbatch.html
source ~/.bash_profile
./build.sh
./hello ${RANDOM}
```

To run you will need to execute this command

```
sbatch non_mpi.slurm
```

This will execute programs ``` biuild.sh and hello ```

to see what these programs do 

``` 
cat build.sh
cat hello.c
```