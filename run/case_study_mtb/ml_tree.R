library(ape)

args <- commandArgs(TRUE)
print(args)
if (length(args)!=2) {
  stop("Need 2 arguments.", call.=FALSE)
}

fname <- args[1]
seed <- as.integer(args[2])

npolysites <- nchar(readLines(paste0("../menardo_seqs/",fname))[2])
ogroup <- substring(readLines(paste0("../menardo_seqs/",fname))[1],2)

system(sprintf('iqtree -s %s -m GTR+G -seed %d -nt 8 -mem 32G', paste0("../menardo_seqs/",fname), seed))
phy_ml <- read.tree(paste0("../menardo_seqs/",fname,".treefile"))

phy_ml <- multi2di(phy_ml)
phy_ml$edge.length <- phy_ml$edge.length * npolysites
phy_ml <- root(phy_ml, outgroup = ogroup)
phy_ml <- drop.tip(phy_ml, ogroup)

write.tree(phy_ml, paste0(fname, ".ml_tree.nwk"))