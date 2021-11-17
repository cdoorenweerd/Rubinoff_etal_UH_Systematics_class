#set working directory
setwd("Dropbox/My Mac (Michael’s MacBook Pro)/Documents/GitHub/2019_fall_UH_Systematics_class/Homework_assignment4/")

#function to reset graphical paramerters
resetPar <- function() {
    dev.new()
    op <- par(no.readonly = TRUE)
    dev.off()
    op
  }

par(resetPar())

#Load packages
library(phytools)
library(geiger)
library(diversitree)
library(stats)

## Continuous Trait Evolution
#read in tree file
anole.tree<-read.tree("Anolis.tre") 

#plot tree file
plotTree(anole.tree,ftype="i",lwd=1)

#read in continuous trait file (Body size)
svl<-read.csv("svl.csv",row.names=1) 
svl<-setNames(svl$svl,rownames(svl))

#view traits
svl

#check if tips and traits are the same
chk<-name.check(anole.tree,svl)
chk


#View tree with dots that represent species sizes
dotTree(anole.tree,svl,length=1,ftype="i")

#ML for ancestral state reconstruction
obj<-contMap(anole.tree,svl,plot=FALSE)
obj

#plot infered ancestral states along the tree 
plot(obj,legend=0.7*max(nodeHeights(anole.tree)), sig=2,fsize=c(0.7,0.9))

#Fitting models of continuous character evolution
fitBM<-fitContinuous(anole.tree,svl,model="BM")
fitOU<-fitContinuous(anole.tree,svl,model="OU")
fitEB<-fitContinuous(anole.tree,svl,model="EB")

#Calculate AIC for different models
aic.vals<-setNames(c(fitBM$opt$aicc,fitOU$opt$aicc,fitEB$opt$aicc),
                   c("BM","OU","EB"))
aic.vals

#calculate weights for different models
aic.w(aic.vals)



## Discrete trait evolution
#read discrete character traits
X<-read.csv("elopomorph.csv",row.names=1)
feed.mode<-setNames(X[,1],rownames(X))
#read eel tree
eel.tree<-read.tree("elopomorph.tre")
eel.tree

chk<-name.check(eel.tree,feed.mode)
chk

#Fitting models of discrete character evolution
fitER<-ace(feed.mode,eel.tree,model="ER",type="discrete")
fitARD<-ace(feed.mode,eel.tree,model="ARD",type="discrete")

#Calculate AIC for different models
aic.vals<-setNames(c(AIC(fitER,k=1),AIC(fitARD,k=2)),
                   c("ER","ARD"))

#calculate weights for different models
aic.w(aic.vals)

#assign col for diferent states
cols<-setNames(c("red","blue"),unique(factor(feed.mode)))
plotTree(eel.tree,fsize=0.8,ftype="i")
nodelabels(node=1:eel.tree$Nnode+Ntip(eel.tree),
           pie=fitER$lik.anc,piecol=cols,cex=0.5)
tiplabels(pie=to.matrix(feed.mode,sort(unique(feed.mode))),piecol=cols,cex=0.3)
add.simmap.legend(colors=cols,prompt=FALSE,x=1,
                  y=1,fsize=0.8,leg=unique(factor(feed.mode)))
