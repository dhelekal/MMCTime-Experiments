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
tr_in <- multi2di(tr_in)

n_tip <- length(tr_in$tip.label)

pos <- sample(1:(n_tip - 2),1)
outgroup <- ifelse(pos > n_tip, extract.clade(tr_in, pos)$tip.label, tr_in$tip.label[pos])
tr_in <- root(tr_in, outgroup=outgroup, resolve.root=T)
tr_in$edge.length <- tr_in$edge.length / 10000L

dates_tab <- read.table(paste0("../gt/dates_", index , ".tab"))
dates <- dates_tab$x
names(dates) <- rownames(dates_tab)

dfile <- tempfile()
cat(length(dates),"\n",file = dfile)
for (i in 1:length(dates)){
  cat(names(dates)[i], dates[i], "\n", append = T, file = dfile)
}

tfile <- tempfile()
write.tree(tr_in, tfile)

ofile <- paste0(outdir,"/res_", index, ".rds")

res <- lsd2(inputTree=tfile, inputDate=dfile, seqLen = 10000L, estimateRoot="a")

saveRDS(res, ofile)