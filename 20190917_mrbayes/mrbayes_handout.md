# 20190917 Bayesian analysis with MrBayes on the UH cluster

Consider: what are the key settings that will determine if your run will be successful? What does it mean to have a successful or a failing run?

Files required:
- Nexus formatted alignment
- Slurm script

[MrBayes](http://nbisweden.github.io/MrBayes/manual.html) is readily available as a module on the cluster, so we can simply load it in our slurm script and start an analysis. But first, prepare the input files and move them to the cluster.

# Prepare input files

Use sftp (Filezilla or Cyberduck) to retrieve the input files that we have prepared for you from the ```pep662_class/class_shared``` folder on the cluster. Copy the folder to your local computer (e.g. to your desktop). Use a text editor to examine the input files and adjust them to your needs.

When ready, use sftp to move the folder with input files to the ```nfs_fs02``` drive on the cluster.

# Starting a job

ALWAYS START SLURM JOBS FROM WITHIN THE ```nfs_fs02``` FOLDER!!!

Connect to the cluster using SSH. Navigate to the ```nfs_fs02``` subfolder that has the input files and start a batch submission

```console
[cdoorenw@login002 ~]$ sbatch script.slurm
```

You can see the status of the queue on our partition or for a username with:

```console
[cdoorenw@login002 ~]$ squeue -p pep662
[cdoorenw@login002 ~]$ squeue -u cdoorenw
```

# MrBayes File format
MrBayes takes standard nexus files. The files for this tutorial should be in your ```pep662_class/class_shared``` folder. 

Open the ```SynallBayes.nex``` in the class shared folder in a text editor.

After the end of the nexus Data block which contains the sequences we are trying to analyze, there is a MrBayes block which provides settings for the analysis you want to run in MrBayes. We have provided comments in this nexus file which are found within the "[]". The computer will ignore text within []. Comments in any scripting language provides a space to give yourself notes on what each line is doing in the anlaysis if necessary. (see below)
 

``` console
begin mrbayes;
   CHARSET Rps5=1-628;      [Character set 1]
   CHARSET MDH=629-1290;    [Character set 2]
   CHARSET 28s=1291-1995;   [Character set 3]
   CHARSET CAD=1996-2774;   [Character set 4]
   CHARSET EF1a=2775-3519;  [Character set 5]
   CHARSET N1=3520-4104;    [Character set 6]
   CHARSET CO3=4105-4757;   [Character set 7]
   CHARSET CO2=4758-5486;   [Character set 8]
   CHARSET CO1=5487-6937;   [Character set 9]
   partition Names = 9: Rps5, MDH, 28s, CAD, EF1a, N1, CO3, CO2, CO1;   [Setting each character set to partitions]

	set autoclose=yes;   [Telling mrbayes to close after analysis finishes]
	[The following lines set up a model in which all nine genes have their unique GTR + invgamma  model]
	set partition=Names;  [setting partitions to names]
	prset ratepr=variable brlenspr=unconstrained:Exp(10.0);  [setting each partition to have differnt rate prior and setting the branch length prior to and unconstrained exponential distribution of 10]
	lset applyto=(1,2,3,4,5,6,7,8,9) nst=6 rates=invgamma; [setting a GTR (nst=6) +I +G model for each of the 9 partitions]
	unlink shape=(all) pinvar=(all) statefreq=(all) revmat=(all); [unlinking the shape parameter, proportion of invarient sites parameter,  statefrequencies parameter and substitution rates parameter for all partitions ]
	mcmcp ngen=10000000 printfreq=1000 samplefreq=1000 nchains=4 nruns=2 savebrlens=yes; [Setting up MCMC to run 10million generations sampling every 1000 generations and conducting 2 runs (analyses each with 4 chains each)]
	mcmc; [starting MCMC]
end;

```

This tutorial MrBayes block sets up a GTR +I+G model for every partition (9) but this is not always appropriate.


The ```applyto``` command allows you to set different models for each partition. 

For example the commands below apply a gtr model to partition 1,2,3 , a HKY model to partition 4,5,6, and a SYM +I +G model to partition 7,8,9.

```
lset applyto=(1,2,3) nst=6;
lset applyto=(4,5,6) nst=2;
lset applyto=(7,8,9) nst=6 rates=invgamma;
prset applyto=(7,8,9) statefreqpr=fixed(equal);
```

## Settings for common evolutionary models

## GTR
    lset applyto=() nst=6                           # GTR
    lset applyto=() nst=6 rates=propinv             # GTR + I
    lset applyto=() nst=6 rates=gamma               # GTR + gamma
    lset applyto=() nst=6 rates=invgamma            # GTR + I + gamma

## SYM

    lset applyto=() nst=6                           # SYM
    prset applyto=() statefreqpr=fixed(equal)

    lset applyto=() nst=6 rates=propinv             # SYM + I
    prset applyto=() statefreqpr=fixed(equal)

    lset applyto=() nst=6 rates=gamma               # SYM + gamma
    prset applyto=() statefreqpr=fixed(equal)

    lset applyto=() nst=6 rates=invgamma            # SYM + I + gamma
    prset applyto=() statefreqpr=fixed(equal)


## HKY

    lset applyto=() nst=2                           # HKY
    lset applyto=() nst=2 rates=propinv             # HKY + I
    lset applyto=() nst=2 rates=gamma               # HKY + gamma
    lset applyto=() nst=2 rates=invgamma            # HKY + I + gamma

## K2P

    lset applyto=() nst=2                           # K2P
    prset applyto=() statefreqpr=fixed(equal)

    lset applyto=() nst=2 rates=propinv             # K2P + I
    prset applyto=() statefreqpr=fixed(equal)

    lset applyto=() nst=2 rates=gamma               # K2P + gamma
    prset applyto=() statefreqpr=fixed(equal)

    lset applyto=() nst=2 rates=invgamma            # K2P + I + gamma
    prset applyto=() statefreqpr=fixed(equal)


## F81

    lset applyto=() nst=1                           # F81
    lset applyto=() nst=1 rates=propinv             # F81 + I
    lset applyto=() nst=1 rates=gamma               # F81 + gamma
    lset applyto=() nst=1 rates=invgamma            # F81 + I + gamma

## Jukes Cantor  

    lset applyto=() nst=1                           # JC
    prset applyto=() statefreqpr=fixed(equal)

    lset applyto=() nst=1 rates=propinv             # JC + I
    prset applyto=() statefreqpr=fixed(equal)

    lset applyto=() nst=1 rates=gamma               # JC + gamma
    prset applyto=() statefreqpr=fixed(equal)

    lset applyto=() nst=1 rates=invgamma            # JC + I + gamma
    prset applyto=() statefreqpr=fixed(equal)


# Running MrBayes on the cluster

You will use a slurm script to run MrBayes on the cluster. 

First, open the ```MrBayes.slurm``` file in the class shared folder in a text editor. It will look like this:

```console
#!/bin/bash
#SBATCH --job-name=MrBayes 
#SBATCH --partition=pep662
#SBATCH --account=pep662_f2019
## 3 day max run time for public partitions, except 4 hour max runtime for the sandbox partition
#SBATCH --time=15-00:00:00 ## time format is DD-HH:MM:SS
## task-per-node x cpus-per-task should not typically exceed core count on an individual node
#SBATCH --nodes=1
#SBATCH --tasks-per-node=19
#SBATCH --cpus-per-task=1
#SBATCH --mem=120G ## max amount of memory per node you require

##SBATCH --core-spec=0 ## Uncomment to allow jobs to request all cores on a node

#SBATCH --error=err-%A.err ## %A - filled with jobid
#SBATCH --output=out-%A.out ## %A - filled with jobid
## Useful for remote notification
#SBATCH --mail-type=BEGIN,END,FAIL,REQUEUE,TIME_LIMIT_80
#SBATCH --mail-user=youremail@hawaii.edu

## All options and environment variables found on schedMD site: http://slurm.schedmd.com/sbatch.html
source ~/.bash_profile

module load bio/MrBayes/3.2.7-intel-2018.5.274-mpi

mb -i SynallBayes.nex

```
## Key Lines

```MrBayes.slurm``` sets up the MrBayes analysis to run on the cluster.

Within in the slurm file, we load MrBayes using  ```module load bio/MrBayes/3.2.7-intel-2018.5.274-mpi```

```mb -i SynallBayes.nex``` executes MrBayes using the input file (-i) ```SynallBayes.nex```

This run should take 5 hours to finish.


# After MrBayes finishes

You should find several new files in the ```nfs_fs02``` subfolder where you ran your analysis. You should find: 

```console
MrBayes.slurm           #slurm file
SynallBayes.nex         #data file
SynallBayes.nex.ckp     #checkpoint file
SynallBayes.nex.mcmc    #mcmc file
SynallBayes.nex.run1.p  #run1 parameter file
SynallBayes.nex.run1.t  #run1 tree file
SynallBayes.nex.run2.p  #run2 parameter file
SynallBayes.nex.run2.t  #run2 tree file
out-3604983.out         #output file
```

# Check parameter files in Tracer

Load the parameter files ```SynallBayes.nex.run1.p``` and  ``` SynallBayes.nex.run2.p  ``` in Tracer to inspect how your MCMC ran.

Examine the different parameters and play with burnin to see if the mcmc sampled parameter/tree space well.

Does it look good?

If it doesnt look good you may need to run your analysis again or change your priors or parameters. 


# Summarizing the estimated parameters and trees 

In order to finish the analysis and obtain a tree you need to summarize the estimated parameters and trees found using MCMC.

Navigate to the folder where you ran your MrBayes analysis. 

You will need to modify your datafile ```SynallBayes.nex``` to prevent it from running the MCMC again when you execute MrBayes.

You can do this using a text editor or in the shell using the program ```nano```.

# To run NANO (a text editor) on the cluster

On the login node, in the folder with your output files, type ```nano SynallBayes.nex``` to open ```SynallBayes.nex```. You need to navigate to the bottom of the MrBayes block below and remove the last line before the end;  ```mcmc; ```

``` console
begin mrbayes;
   CHARSET Rps5=1-628;      [CHARSET 1]
   CHARSET MDH=629-1290;    [CHARSET 2]
   CHARSET 28s=1291-1995;   [CHARSET 3]
   CHARSET CAD=1996-2774;   [CHARSET 4]
   CHARSET EF1a=2775-3519;  [CHARSET 5]
   CHARSET N1=3520-4104;    [CHARSET 6]
   CHARSET CO3=4105-4757;   [CHARSET 7]
   CHARSET CO2=4758-5486;   [CHARSET 8]
   CHARSET CO1=5487-6937;   [CHARSET 9]
   partition Names = 9: Rps5, MDH, 28s, CAD, EF1a, N1, CO3, CO2, CO1;   [Setting each characterset to partitions]

	set autoclose=yes;   [Telling mrbayes to close after analysis finishes]
	[The following lines set up a model in which all nine genes have their unique GTR + invgamma  model]
	set partition=Names;  [setting partitions to names]
	prset ratepr=variable brlenspr=unconstrained:Exp(10.0);  [setting each partition to have differnt rate prior and setting the branch length prior to and unconstrained exponential distribution of 10]
	lset applyto=(1,2,3,4,5,6,7,8,9) nst=6 rates=invgamma; [setting a GTR (nst=6) +I +G model for each of the 9 partitions]
	unlink shape=(all) pinvar=(all) statefreq=(all) revmat=(all); [unlinking the shape proportion of invarient sites statefrequencies and substitution rates for each partition ]
	mcmcp ngen=10000000 printfreq=1000 samplefreq=1000 nchains=4 nruns=2 savebrlens=yes; [Setting up MCMC to run 10million generations sampling every 1000 generations and conducting 2 runs (analyses each with 4 chains)]
	mcmc; [starting MCMC]
end;

```

Once ```mcmc;``` is removed the mrbayes block should look like this and should be ready for burnin and summing the parameters and trees.

``` console
begin mrbayes;
   CHARSET Rps5=1-628;      [CHARSET 1]
   CHARSET MDH=629-1290;    [CHARSET 2]
   CHARSET 28s=1291-1995;   [CHARSET 3]
   CHARSET CAD=1996-2774;   [CHARSET 4]
   CHARSET EF1a=2775-3519;  [CHARSET 5]
   CHARSET N1=3520-4104;    [CHARSET 6]
   CHARSET CO3=4105-4757;   [CHARSET 7]
   CHARSET CO2=4758-5486;   [CHARSET 8]
   CHARSET CO1=5487-6937;   [CHARSET 9]
   partition Names = 9: Rps5, MDH, 28s, CAD, EF1a, N1, CO3, CO2, CO1;   [Setting each characterset to partitions]

	set autoclose=yes;   [Telling mrbayes to close after analysis finishes]
	[The following lines set up a model in which all nine genes have their unique GTR + invgamma  model]
	set partition=Names;  [setting partitions to names]
	prset ratepr=variable brlenspr=unconstrained:Exp(10.0);  [setting each partition to have differnt rate prior and setting the branch length prior to and unconstrained exponential distribution of 10]
	lset applyto=(1,2,3,4,5,6,7,8,9) nst=6 rates=invgamma; [setting a GTR (nst=6) +I +G model for each of the 9 partitions]
	unlink shape=(all) pinvar=(all) statefreq=(all) revmat=(all); [unlinking the shape proportion of invarient sites statefrequencies and substitution rates for each partition ]
	mcmcp ngen=10000000 printfreq=1000 samplefreq=1000 nchains=4 nruns=2 savebrlens=yes; [Setting up MCMC to run 10million generations sampling every 1000 generations and conducting 2 runs (analyses each with 4 chains)]

end;

```

# Burnin and summarizing the parameters and trees in MrBayes

Because of the way any Bayesian analysis and MCMC works we must summarize all the parameter values and trees we generated to make a Bayesian consensus tree with posterior probablilites. 

To do this we have to start an interactive session on a compute node in the cluster. 

You can access a compute node using either the pep662 partition   

```srun -I --partition pep662 --account pep662_f2019 --cores 1 --mem=4gb --time 0-04:00:00 --pty /bin/bash```

or if someone is using the pep662 partition try running in the sandbox partition

```srun -I --partition sandbox --cores 1 --mem=4gb --time 0-04:00:00 --pty /bin/bash```

Once on the compute node is active, the @ address changes from [cdoorenw@login002 ~]$ to something like: [cdoorenw@node-0040 ~]$

Load MrBayes.

```module load bio/MrBayes/3.2.7-intel-2018.5.274-mpi```

then navigate to the folder which contains your datafile ```SynallBayes.nex```

and execute MrBayes with the command below.

``` mb ```

you should see something like this 
```console


                            MrBayes 3.2.7 x86_64

                      (Bayesian Analysis of Phylogeny)

                             (Parallel version)
                         (1 processors available)

              Distributed under the GNU General Public License


               Type "help" or "help <command>" for information
                     on the commands that are available.

                   Type "about" for authorship and general
                       information about the program.


MrBayes >

```

Load the modified dataset file ```SynallBayes.nex``` by using this command


``` execute SynallBayes.nex```

After the file is loaded it should say on the last two lines

```
   Exiting mrbayes block
   Reached end of file
```

Note the MCMC didnt start which is what we wanted.

## Summarizing Parameters

Once loaded type ```sump``` to summarize the estimated parameters for this analysis 

Default burnin is 25% but you can change this by ```sump burnin=1000``` or ```sump burnin=5000``` to burnin 1000 parameters or 5000 parameters respectivly. 

After summarizing the parameters check ESS PSRF+ values in the outputed table ESS for each parameter should be > than 200 and PSRF+ should be ~ 1.00. If not check tracer again. 

## Summarizing Trees

Type ```sumt``` to summarize the trees for this analysis 

Default burnin is 25% but you can change this by ```sumt burnin=1000``` or ```sumt burnin=5000``` to burnin 1000 parameters or 5000 parameters respectivly. 

There should be ```SynallBayes.nex.con.tre``` which is your consensus tree with posterior probablities 

Now your done with MrBayes 

you can quit the program with ```quit``` command

Type ```ls``` and you should see ```SynallBayes.nex.con.tre``` in the folder.

Open ```SynallBayes.nex.con.tre``` in figtree for viewing. 


# Alternative approach

The method described above gives you the best control over your data and ensures thorough checking of your output. If you feel comfortable however, a shortcut method would be to include the ```sump``` and ```sumt``` commands directly in the initial input file, after the ```mcmc``` command. Your bayes block would then look like:

``` console
begin mrbayes;
   CHARSET Rps5=1-628;      [CHARSET 1]
   CHARSET MDH=629-1290;    [CHARSET 2]
   CHARSET 28s=1291-1995;   [CHARSET 3]
   CHARSET CAD=1996-2774;   [CHARSET 4]
   CHARSET EF1a=2775-3519;  [CHARSET 5]
   CHARSET N1=3520-4104;    [CHARSET 6]
   CHARSET CO3=4105-4757;   [CHARSET 7]
   CHARSET CO2=4758-5486;   [CHARSET 8]
   CHARSET CO1=5487-6937;   [CHARSET 9]
   partition Names = 9: Rps5, MDH, 28s, CAD, EF1a, N1, CO3, CO2, CO1;   [Setting each characterset to partitions]

	set autoclose=yes;   [Telling mrbayes to close after analysis finishes]
	[The following lines set up a model in which all nine genes have their unique GTR + invgamma  model]
	set partition=Names;  [setting partitions to names]
	prset ratepr=variable brlenspr=unconstrained:Exp(10.0);  [setting each partition to have differnt rate prior and setting the branch length prior to and unconstrained exponential distribution of 10]
	lset applyto=(1,2,3,4,5,6,7,8,9) nst=6 rates=invgamma; [setting a GTR (nst=6) +I +G model for each of the 9 partitions]
	unlink shape=(all) pinvar=(all) statefreq=(all) revmat=(all); [unlinking the shape proportion of invarient sites statefrequencies and substitution rates for each partition ]
	mcmcp ngen=10000000 printfreq=1000 samplefreq=1000 nchains=4 nruns=2 savebrlens=yes; [Setting up MCMC to run 10million generations sampling every 1000 generations and conducting 2 runs (analyses each with 4 chains)]
	mcmc; [starting MCMC]
    sump burninfrac=0.25 [summarizing parameters with burnin 25%]
    sumt burninfrac=0.25 [summarizing trees with burnin 25%]
end;

```

This will apply a burnin value of 25% of the trees. Always use Tracer to check if that was appropriate.

