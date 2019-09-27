library(RevGadgets)
library(ggtree)
library(ggplot2)

# files
tree_fn = "five_area_DEC.tre"
label_fn = "five_area_DEC.state_labels.txt"
color_fn = "range_colors_5area.txt"

# set area names
area_names = c("W","E","N","A","B")

# get state labels
state_descriptions = read.csv(label_fn, header=T,
                              sep=",", colClasses="character")

# map presence-absence ranges to area names
range_labels = sapply(state_descriptions$range[2:nrow(state_descriptions)],
    function(x) {
        present = as.vector(gregexpr(pattern="1", x)[[1]])
        paste( area_names[present], collapse="")
    })

state_labels = range_labels
names(state_labels) = as.character(1:(nrow(state_descriptions)-1))

# generate colors for ranges
range_color_list = read.csv(color_fn, header=T, sep=",",
                            na.string="QQ", colClasses="character")
range_colors = range_color_list$color[ match(range_labels, range_color_list$range) ]

# plot ranges
plot_ancestral_states(tree_file=tree_fn,
                      title="Five state DEC",
                      tree_layout="rectangular",
                      include_start_states=TRUE,
                      shoulder_label_size=0,
                      summary_statistic="MAPRange",
                      state_labels=state_labels,
                      state_colors=range_colors,
                      tip_node_size=4,
                      node_label_size=2,
                      node_size_range=c(1,4),
                      tip_label_size=2,
                      alpha=1,
                      show_posterior_legend=TRUE,
                      show_tree_scale=TRUE)