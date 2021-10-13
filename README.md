# PEPS 662

This repository holds documents for the University of Hawaii at Manoa PEPS 662 Systematics course. Below is some general information and software we recommend you install for the homework assignments.

## File extensions

To ensure you know what file type you have and to prevent issues with matching the file names as they appear on your local system and the cluster, it is best to have your operating system set to show all file extensions. Instructions on how to do this:

- [Mac OS](https://support.apple.com/guide/mac-help/show-or-hide-filename-extensions-on-mac-mchlp2304/mac)

- [Windows](https://fileinfo.com/help/windows_10_show_file_extensions)


## Install on your computer locally:

### SFTP File transfer software
[Filezilla (client)](https://filezilla-project.org) or [Cyberduck](https://cyberduck.io/download/). We will use this to move files between your local computer and the UH Mana supercomputing cluster.

### A better text editor
Most basic text editors unfortunately change more than they let you know, such as the way line breaks managed or the encoding of the document, which can cause errors when moving between operating systems (e.g., Windows to Linux). They also lack critical tools for troubleshooting error messages from phylogenetic software, such as line numbers. Therefore, use a better text editor. We recommend  [BBEdit](https://www.barebones.com/products/bbedit/) (Mac),  [Notepad++](https://notepad-plus-plus.org) (PC) or [Visual Studio Code](https://code.visualstudio.com). BBEdit and Notepad++ are lightweight text editors, Visual Studio Code is a larger program that includes a terminal interface to directly run and debug scripts (like e.g. in RStudio).

### Sequence alignment / editing
[Aliview](http://www.ormbunkar.se/aliview/downloads/) or, if your lab has a license, [Geneious](https://www.geneious.com/)

### Processing results files
- [Tracer](https://beast.community/tracer) for visualizing Bayesian convergence statistics
- [FigTree](https://github.com/rambaut/figtree/releases) for visualizing trees
- [R](https://www.r-project.org/) and [Rstudio](https://www.rstudio.com/)
- [the R package RevGadgets](https://revbayes.github.io/tutorials/intro/revgadgets.html)

### Neighbor joining / maximum parsimony analyses
- [Paup*](http://phylosolutions.com/paup-test/)

## Software that we will use on the [Mana](https://datascience.hawaii.edu/hpc/) supercomputing cluster:

- [Anaconda](https://anaconda.org/) environments
- [IQ-tree](http://www.iqtree.org/) maximum likelihood
- [RevBayes](https://revbayes.github.io/) probablistic graphical modelling and Bayesian inference
