# Homework assignment 4: Character State Evolution
Due Dec 5

For this homework, we are going to conduct character state evolution analyses based on two different datasets. The first is looking at how body size evolved in anole lizards and the second is looking at how feeding strategy evoloved in eels. These methods are some of the first steps you would take after constructing a tree to see how traits in the study group evolved.

You will run two analyses and test different models of character state evolution:
- Ancestral state reconstruction based on continuous characters
- Fit different models and use AIC to determine which model best fit the data
- Ancestral state reconstruction based on discrete characters
- Fit different models and use AIC to determine which model best fit the data


## Homework assignment 4 REPORT:

This assignment is worth 25 points!

Use a scientific writing style, the homework report will follow the template of a short research publication. Some quick tips to enhance your scientific writing: https://www.scitechedit.com/en-gb/helpful-resources/newsletters/502-improve-your-scientific-writing .

The report must not exceed two (2) pages with 11pt font or larger, EXCLUDING figures. Append figures after the text. Deadline to turn in is indicated in the syllabus. START EARLY with the analyses to allow time for troubleshooting, and sufficient time to ultimately write the report.


- Title, author, date
- An introduction section. Cover the following topics briefly: (1) What is phylogenetic comparative methods, (2) What is the differences between the character types, what models can we use for each. (3) How do we determine which model fits the data and the tree best? 
- A methods section explaining the analyses and settings used for each section of the assignment: Infering ancestral states on a phylogeny. Which models of evolution did we test for each character and phylogeny.
- A results and discussion section describing the results. Cover: (1) How many times did size change in the anolis tree? what is the general pattern do we see with size? What was infered to be the general ancestral size? (2) How many times did biting and suction evolove in the eel tree. What was the ancestral state? Do you see a pattern in this character state if so can you describe?
- Figures of the resulting trees and other figures that are relevant to the results, numbered in order as they appear in the text.

The report must not exceed two (2) pages with 11pt font or larger, excluding figures. Deadline to turn in is indicated in the syllabus.

## 1. USING R or R studio

1. All files needed to run analyses for this homework are in the `peps662_group/Homework4` folder on the mana cluster. You will need to copy the contents of this folder to your local computer.

2. You can download the program R using the links below. I recommend using R studio (on top of R) since it has a bit more friendly user interface.

```
https://cran.rstudio.com/
https://posit.co/download/rstudio-desktop/
```

3. I have a commented R script that we can use to conduct the homework:

```
character_state_evolution.R
```

Check that you have the following files to conduct the homework assignment:

```
Anolis.tre
svl.csv
elopomorph.csv
elopomorph.tre
```


R script for this assignment
```
## Homework 4 November 14 2023

## Character state reconstruction in R

#Install packages if you have not done so previously
install.packages('phytools')
install.packages('geiger')
install.packages('plotrix')
#Load packages
library(phytools)
library(geiger)

#set working directory
setwd("Dropbox/My Mac (Michael’s MacBook Pro)/Documents/GitHub/2019_fall_UH_Systematics_class/Homework_assignment4/")

## Continuous Trait Evolution
#read in tree file
anole.tree<-read.tree("Anolis.tre") 

#plot tree file
plotTree(tree = anole.tree,ftype="i",lwd=1,fsize=0.5)

#read in continuous trait file (Body size)
svl<-read.csv("svl.csv",row.names=1) 
svl<-setNames(svl$svl,rownames(svl))

#view traits
svl

#check if tips and traits are the same
name.check(anole.tree,svl)

#View tree with dots that represent species sizes (for fun)
dotTree(anole.tree,svl,length=1,ftype="i",fsize=.5)

#ML for ancestral state reconstruction
obj<-contMap(tree = anole.tree,svl,plot=FALSE)
obj

#plot infered ancestral states along the tree 
plot(obj,legend=0.7*max(nodeHeights(anole.tree)), sig=2,fsize=.5)


#Fitting models of continuous character evolution
#fit brownian motion model
fitBM<-fitContinuous(anole.tree,svl,model="BM")
#fit Ornstein–Uhlenbeck model
fitOU<-fitContinuous(anole.tree,svl,model="OU")
#fit early burst model
fitEB<-fitContinuous(anole.tree,svl,model="EB")

#Calculate AIC for different models
aic.vals<-setNames(c(fitBM$opt$aicc,fitOU$opt$aicc,fitEB$opt$aicc),
                   c("BM","OU","EB"))
#AIC closest to 0 is best
aic.vals

#calculate weights for different models
aic.w(aic.vals)

## Discrete trait evolution (Feeding) in elopomorph fish
#read discrete character traits
X<-read.csv("elopomorph.csv",row.names=1)
feed.mode<-setNames(X$feed_mode,rownames(X))
#read eel tree
eel.tree<-read.tree("elopomorph.tre")
eel.tree

#check if tips and traits are the same
name.check(eel.tree,feed.mode)

#change feed.mode data to factor
feed.mode<-as.factor(feed.mode)

#plot eel tree
plotTree(eel.tree,ftype="i",lwd=1,fsize=.5)

#save as PDF
pdf("IBD_all_log2_subdivided2.pdf",width = 8,height = 8, useDingbats=FALSE)
dev.off
#Fitting models of discrete character evolution
#fit equal rates model
fitER<-ace(feed.mode,eel.tree,model="ER",type="discrete")
#fit all rates different model
fitARD<-ace(feed.mode,eel.tree,model="ARD",type="discrete")

#Calculate AIC for different models
aic.vals<-setNames(c(AIC(fitER,k=1),AIC(fitARD,k=2)),c("ER","ARD"))

#calculate weights for different models
aic.w(aic.vals)

#assign col for diferent states
plotTree(eel.tree, fsize=0.7, ftype="i", lwd=1,fsize=.5)
cols<-setNames(c("red", "blue"), levels(feed.mode))
nodelabels(pie=fitER$lik.anc, piecol=cols, cex=0.4)
tiplabels(pie=to.matrix(feed.mode[eel.tree$tip.label], levels(feed.mode)), piecol =cols, cex=0.3)
add.simmap.legend(leg = levels(feed.mode), colors=cols, prompt=FALSE, x = 1, y=1, fsize=0.8)
```