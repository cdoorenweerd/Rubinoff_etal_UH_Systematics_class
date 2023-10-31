################################################################################
#
# RevBayes Example: Bayesian inference of phylogeny using a GTR+Gamma+Inv
#                   substitution model for a 2-gene partition model
#                   Modified for Hyles genes
# authors: Michael Landis, Sebastian Hoehna, Tracy A. Heath and Brian R. Moore
# modified by: Michael San Jose
#
################################################################################


#######################
# Reading in the Data #
#######################

# read in the character data 
### you will need to change this to match the data your dataset
filenames <- v("data/Hyles_all_Mrbayes_Cad.nex", "data/Hyles_all_Mrbayes_EF1a.nex", "data/Hyles_all_Mrbayes_Wingless.nex", "data/Hyles_all_Mrbayes_mtDNA.nex")

n_data_subsets <- filenames.size()
for (i in 1:n_data_subsets) {
    data[i] = readDiscreteCharacterData(filenames[i])
    num_sites[i] = data[i].nchar()
}

# Get some useful variables from the data. We need these later on.
n_taxa <- data[1].ntaxa()
n_branches <- 2 * n_taxa - 3
taxa <- data[1].taxa()


# Create some vector for the moves and monitors of this analysis
# this setup revbayes MCMC
moves    = VectorMoves()
monitors = VectorMonitors()

##################################
#      Substitution Model        #
#   Loop over each data subset   #
#    GTR model for each gene     #
##################################

####################################################################
## alternatively you can specify a different model for each gene   #
##        you check the tutorial online for details                #
####################################################################
for (i in 1:n_data_subsets) {

    # exchangeability rates for partition i
    er_prior[i] <- v(1,1,1,1,1,1)
    er[i] ~ dnDirichlet(er_prior[i])
    moves.append( mvSimplexElementScale(er[i], alpha=10, tune=true, weight=3) )

    # stationary frequencies for partition i
    pi_prior[i] <- v(1,1,1,1)
    pi[i] ~ dnDirichlet(pi_prior[i])
    moves.append( mvSimplexElementScale(pi[i], alpha=10, tune=true, weight=2) )

    # rate matrix for partition i
    # setup a GTR MODEL
    Q[i] := fnGTR(er[i],pi[i]) 
  
    # +Gamma for partition i
    alpha[i] ~ dnUniform(0, 1E8)
    gamma_rates[i] := fnDiscretizeGamma( alpha[i], alpha[i], 4, false )

    # add moves for the alpha parameter
    moves.append( mvScale(alpha[i],weight=2) )

    # the probability of a site being invariable
    pinvar[i] ~ dnBeta(1,1)
    moves.append( mvBetaProbability(pinvar[i], delta=10, tune=true, weight=2.0) )

}


##############
# Tree model #
##############

# you will need to set up outgroup for the dataset
# for the syndemis dataset it will be jd4556_Dichelia_historionana
out_group = clade("ms1512_Galii_AK")
# Prior distribution on the tree topology
topology ~ dnUniformTopology(taxa, outgroup=out_group)
moves.append( mvNNI(topology, weight=n_taxa/2.0) )
moves.append( mvSPR(topology, weight=n_taxa/10.0) )

# Branch length prior
for (i in 1:n_branches) {
    bl[i] ~ dnExponential(10.0)
    moves.append( mvScale(bl[i]) )
}

TL := sum(bl)

psi := treeAssembly(topology, bl)


##############################
# Partition rate multipliers #
##############################

# specify a rate multiplier for each partition
part_rate_mult ~ dnDirichlet( rep(10.0, n_data_subsets) )
moves.append( mvBetaSimplex(part_rate_mult, alpha=1.0, tune=true, weight=n_data_subsets) )
moves.append( mvDirichletSimplex(part_rate_mult, alpha=1.0, tune=true, weight=2.0) )

# Note that here we are dividing two vectors element-wise, i.e., 
# each element of part_rate_mult gets divided by the corresponding
# element of num_sites. Then we multiply the result by sum(num_sites),
# which is just a scalar. This operation ensures that the mean of
# partition-specific branch lengths, weighted by the number of sites
# in each partition, stays equal to the branch lengths we are 
# actually sampling.

part_rate := part_rate_mult / num_sites * sum(num_sites)


################################
# PhyloCTMC Model              #
# Continuous time markov chain #
################################


for (i in 1:n_data_subsets) {
    phyloSeq[i] ~ dnPhyloCTMC(tree=psi, Q=Q[i], branchRates=part_rate[i], siteRates=gamma_rates[i], pInv=pinvar[i], type="DNA")
    phyloSeq[i].clamp(data[i])
}
############
# Analysis #
############
mymodel = model(psi)
# add monitors

#### changing these monitors will affect your MCMC (How many generations between collection a sample) if your MCMC runs poorly try modifing these values may help. 
#### 
monitors.append( mnModel(filename="output/Hyles_bayes.log",printgen=100) )
monitors.append( mnFile(psi, filename="output/Hyles_bayes.trees", printgen=100) )
monitors.append( mnScreen(TL, printgen=500) )

# run the analysis
#### changing the MCMC parameters will affect also affect your MCMC (How many generations total it will run and how many runs total) if your MCMC runs poorly try modifing these values may help. 

#### changing the runs parameter (nruns=2) tell revbayes how many chains to use in the MCMC
mymcmc = mcmc(mymodel, moves, monitors, nruns=2, combine="mixed")
### This analyses will run for 150000 generations we will collect 1500 total samples from each run (3000 total). adding more generations can help MCMC too
mymcmc.run(150000,tuningInterval=200)


#Quit
q()
