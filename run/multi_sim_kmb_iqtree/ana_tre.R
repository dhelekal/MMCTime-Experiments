library(ape)
library(MMCTime)

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
tr_in <- multi2di(tr_in)

n_tip <- length(tr_in$tip.label)

pos <- sample(1:(n_tip - 2),1)
outgroup <- ifelse(pos > n_tip, extract.clade(tr_in, pos)$tip.label, tr_in$tip.label[pos])
tr_in <- root(tr_in,outgroup=outgroup, resolve.root=T)
tr_in$edge.length <- round(tr_in$edge.length)

dates_tab <- read.table(paste0("../gt/dates_", index , ".tab"))
dates <- dates_tab$x
names(dates) <- rownames(dates_tab)

res <- mmctime(tr_in, dates, n_draws=1e3L, thin=3e3L, n_chain=4, mm_sd=.7, model="km_beta", verbose=F)

saveRDS(res, paste0(outdir,"/res_", index, ".rds"))