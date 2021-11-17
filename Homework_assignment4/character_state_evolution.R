## Homework 4 November 16 2021

## Character state reconstruction in R

#Load packages
library(phytools)
library(geiger)

#set working directory
setwd("Dropbox/My Mac (Michael’s MacBook Pro)/Documents/GitHub/2019_fall_UH_Systematics_class/Homework_assignment4/")

## Continuous Trait Evolution
#read in tree file
anole.tree<-read.tree("Anolis.tre") 

#plot tree file
plotTree(anole.tree,ftype="i",lwd=1,fsize=.5)

#read in continuous trait file (Body size)
svl<-read.csv("svl.csv",row.names=1) 
svl<-setNames(svl$svl,rownames(svl))

#view traits
svl

#check if tips and traits are the same
chk<-name.check(anole.tree,svl)
chk


#View tree with dots that represent species sizes
dotTree(anole.tree,svl,length=1,ftype="i",fsize=.5)

#ML for ancestral state reconstruction
obj<-contMap(anole.tree,svl,plot=FALSE)
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

## Discrete trait evolution
#read discrete character traits
X<-read.csv("elopomorph.csv",row.names=1)
feed.mode<-setNames(as.factor(X$feed_mode),rownames(X))
#read eel tree
eel.tree<-read.tree("elopomorph.tre")
eel.tree

chk<-name.check(eel.tree,feed.mode)
chk

#plot eel tree
#plot tree file
plotTree(eel.tree,ftype="i",lwd=1,fsize=.5)

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