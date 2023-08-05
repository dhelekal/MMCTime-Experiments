library(MMCTime)
library(ape)
library(ggtree)
library(ggplot2)
library(treeio)

set.seed(7)

n_pts <- 10

samp_t <- 2020:(2020-n_pts+1)
n_samp <- rep(5, n_pts)

ntip <-sum(n_samp)

mu <- 1.5
sim_km <- simulate_kingman(samp_t, n_samp, 1/10)$phy
sim_mm <- simulate_beta(samp_t, n_samp, 1/8, 0.2)$phy

pdf("poly_ex.pdf", 10,10)
ggtree(sim_km, mrsd='2020-01-01') + geom_tiplab() + theme_tree2()
ggtree(sim_mm, mrsd='2020-01-01') + geom_tiplab()  + theme_tree2()
dev.off()

nnode_mm <- sim_mm$Nnode
n_mm <- ntip + nnode_mm
mm_labs <- sim_mm$node.label[sapply(1:nnode_mm, function(i) length(which(sim_mm$edge[,1] == ntip+i))>2)]