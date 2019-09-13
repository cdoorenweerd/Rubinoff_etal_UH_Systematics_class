# 20190917 Bayesian analysis with MrBayes on the UH cluster

Consider: what are the key settings that will determine if your run will be successful? What does it mean to have a successful or a failing run?

Files required:
- Nexus formatted alignment
- Slurm script

[MrBayes](http://nbisweden.github.io/MrBayes/manual.html) is readily available as a module on the cluster, so we can simply load it in our slurm script and start an analysis. But first, prepare the input files and move them to the cluster.

# Prepare input files

Now that our environment is set-up, we can prepare the input files. Use sftp (Filezilla or Cyberduck) to retrieve the input files from the ```pep662_class/class_shared``` folder on the cluster. Copy the folder to your local computer (e.g. to your desktop). Use a text editor to examine the input files and adjust them to your needs.

When ready, use sftp to move the folder with input files to the ```nfs_fs02``` drive on the cluster.

# Starting a job

ALWAYS START SLURM JOBS FROM WITHIN THE ```nfs_fs02``` FOLDER!!!

Connect to the cluster using SSH. Navigate to the ```nfs_fs02``` subfolder that has the input files and start a batch submission

```console
[cdoorenw@login002 ~]$ sbatch <slurm script>
```

You can see the status of queue on our partition with:

```console
[cdoorenw@login002 ~]$ squeue -p pep662
[cdoorenw@login002 ~]$ squeue -u pep662_f2019
```