## Character state reconstruction in R

# Install packages (run once, then leave commented out)
# install.packages('phytools')
# install.packages('geiger')

# Load packages
library(phytools)
library(geiger)

# Set working directory
setwd("~/Downloads/Homework4/")

## Continuous Trait Evolution
# Read in tree file
anole.tree <- read.tree("Anolis.tre")

# Plot tree file
plotTree(tree = anole.tree, ftype = "i", lwd = 1, fsize = 0.5)

# Read in continuous trait file (body size)
svl <- read.csv("svl.csv", row.names = 1)
svl <- setNames(svl$svl, rownames(svl))

# View traits
svl

# Check if tips and traits are the same
name.check(anole.tree, svl)

# View tree with dots that represent species sizes (for fun)
dotTree(anole.tree, svl, length = 1, ftype = "i", fsize = 0.5)

# ML for ancestral state reconstruction
obj <- contMap(tree = anole.tree, svl, plot = FALSE)
obj

# Plot inferred ancestral states along the tree
plot(obj, legend = 0.7 * max(nodeHeights(anole.tree)), sig = 2, fsize = 0.5)


# Fitting models of continuous character evolution
# Fit Brownian motion model
fitBM <- fitContinuous(anole.tree, svl, model = "BM")
# Fit Ornstein-Uhlenbeck model
fitOU <- fitContinuous(anole.tree, svl, model = "OU")
# Fit early burst model
fitEB <- fitContinuous(anole.tree, svl, model = "EB")

# Calculate AICc for different models
aicc.vals <- setNames(c(fitBM$opt$aicc, fitOU$opt$aicc, fitEB$opt$aicc),
                      c("BM", "OU", "EB"))
# LOWEST AICc is best (values can be negative, e.g. -20 beats -5)
aicc.vals

# Calculate Akaike weights for different models
aic.w(aicc.vals)

#Save plot for anolis tree
pdf("Anolis_ASR.pdf", width = 8, height = 8, useDingbats = FALSE)
plot(obj, legend = 0.7 * max(nodeHeights(anole.tree)), sig = 2, fsize = 0.5)
dev.off()



## Discrete trait evolution (feeding) in elopomorph fish
# Read discrete character traits
X <- read.csv("elopomorph.csv", row.names = 1)
feed.mode <- setNames(X$feed_mode, rownames(X))

# Read eel tree
eel.tree <- read.tree("elopomorph.tre")
eel.tree

# Check if tips and traits are the same
name.check(eel.tree, feed.mode)

# Change feed.mode data to factor
feed.mode <- as.factor(feed.mode)
levels(feed.mode)   # check the number of states (colors below assume 2)

# Plot eel tree
plotTree(eel.tree, ftype = "i", lwd = 1, fsize = 0.5)

# Fitting models of discrete character evolution
# Fit equal rates model
fitER <- ace(feed.mode, eel.tree, model = "ER", type = "discrete")
# Fit all rates different model
fitARD <- ace(feed.mode, eel.tree, model = "ARD", type = "discrete")

# Calculate AIC for different models
# (leave k at its default of 2; ape counts the parameters itself)
aic.vals <- setNames(c(AIC(fitER), AIC(fitARD)), c("ER", "ARD"))
# LOWEST AIC is best
aic.vals

# Calculate Akaike weights for different models
aic.w(aic.vals)

# Use whichever model has the lower AIC for the reconstruction
best <- if (aic.vals["ER"] <= aic.vals["ARD"]) fitER else fitARD
best.name <- names(which.min(aic.vals))
best.name

# Assign colors for different states
cols <- setNames(c("red", "blue"), levels(feed.mode))

# Plot ancestral state reconstruction to screen
plotTree(eel.tree, ftype = "i", lwd = 1, fsize = 0.5)
nodelabels(pie = best$lik.anc, piecol = cols, cex = 0.4)
tiplabels(pie = to.matrix(feed.mode[eel.tree$tip.label], levels(feed.mode)),
          piecol = cols, cex = 0.3)
add.simmap.legend(leg = levels(feed.mode), colors = cols, prompt = FALSE,
                  x = 1, y = 1, fsize = 0.8)

# Save the ancestral state reconstruction as a PDF
pdf("eel_feeding_ASR.pdf", width = 8, height = 8, useDingbats = FALSE)
plotTree(eel.tree, ftype = "i", lwd = 1, fsize = 0.5)
nodelabels(pie = best$lik.anc, piecol = cols, cex = 0.4)
tiplabels(pie = to.matrix(feed.mode[eel.tree$tip.label], levels(feed.mode)),
          piecol = cols, cex = 0.3)
add.simmap.legend(leg = levels(feed.mode), colors = cols, prompt = FALSE,
                  x = 1, y = 1, fsize = 0.8)
dev.off()
