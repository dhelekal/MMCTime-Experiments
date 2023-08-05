library(ape)

args <- commandArgs(TRUE)
print(args)
if (length(args)!=3) {
  stop("Need 3 arguments.", call.=FALSE)
}

nsites <- 1000L

mu <- as.numeric(args[1])
sigma <- as.numeric(args[2]) 
index <- as.integer(args[3]) 
seed <- index + trunc(sigma * 1200 + mu*10000 + 1347000)

set.seed(seed)

tre <- multi2di(read.tree(paste0("../gt/tree_", index,".nwk")))

tre$edge.length <- sapply(tre$edge.length, function (x) if(abs(x) < 1e-8) 0 else rgamma(1,shape = x * mu / sigma, scale = sigma))
tre$node.label <- NULL

write.tree(tre, paste0("tree_clock_", index,".nwk"))
system(sprintf('seq-gen -l %d -s %f -m HKY -z %d < tree_clock_%d.nwk > seqs_%d.nex',nsites,1/nsites,seed,index,index))
system(sprintf('iqtree -s seqs_%d.nex -m HKY -seed %d -nt 1 -mem 4G', index, seed))

tre_ml <- read.tree(paste0("seqs_",index,".nex.treefile"))
tre_ml$edge.length <- tre_ml$edge.length*nsites

write.tree(tre_ml, paste0("tree_ml_", index,".nwk"))


