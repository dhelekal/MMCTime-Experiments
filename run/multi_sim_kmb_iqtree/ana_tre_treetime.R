library(ape)
library(Rlsd2)

args <- commandArgs(TRUE)
print(args)
if (length(args)!=2) {
  stop("Need 2 arguments.", call.=FALSE)
}

outdir <- as.character(args[1])
index <- as.integer(args[2]) 

set.seed(index)

tre_file <- paste0("tree_ml_",index,".nwk")
tr_in <- read.tree(tre_file)
tr_in <- di2multi(tr_in)

n_tip <- length(tr_in$tip.label)

pos <- sample(1:(n_tip - 2),1)
outgroup <- ifelse(pos > n_tip, extract.clade(tr_in, pos)$tip.label, tr_in$tip.label[pos])
tr_in <- root(tr_in, outgroup=outgroup, resolve.root=T)
tr_in$edge.length <- tr_in$edge.length / 10000L

dates_tab <- read.table(paste0("../gt/dates_", index , ".tab"))
dates <- data.frame(name=rownames(dates_tab), date=dates_tab$x)

dfile <- tempfile()
write.csv(dates,dfile, row.names = FALSE,quote=F)

#dfile <- paste0("../gt/dates_", index , ".tab")

tfile <- tempfile()
write.tree(tr_in, tfile)

afile <- paste0("seqs_", index, ".nex")

system(paste0("treetime --tree '", tfile ,"' --dates '", dfile ,"' --aln '", afile, "' --outdir '", outdir, "' --coalescent const --max-iter 150 --relax 5.0 0 --time-marginal false --rng-seed ", index))