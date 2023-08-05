library(ape)
library(MMCTime)

args <- commandArgs(TRUE)
print(args)
if (length(args)!=3) {
  stop("Need 3 arguments.", call.=FALSE)
}

tr_name <- args[1]
mod <- args[2]
seed <- as.integer(args[3])

tree_in <- read.tree(paste0("ml_trees/",tr_name, ".fasta.ml_tree.nwk"))
tree_in <- multi2di(tree_in)

supp <- read.delim("menardo_supplementary_table1.txt", header=T, sep = "\t")
dates_tab <- supp[,c("Genome.name","Year.of.sampling")]
rownames(dates_tab) <- dates_tab[,"Genome.name"]

dates <- as.numeric(dates_tab[tree_in$tip.label,"Year.of.sampling"])
names(dates) <- tree_in$tip.label

missing_dates <- names(dates)[which(is.na(dates))]

tree_in <- drop.tip(tree_in, missing_dates)
dates <- dates[tree_in$tip.label]

res <- mmctime(tree_in, dates, n_draws=1e3L, thin=2e3L, n_chain=4, model=mod, verbose=F, fix_root=T)
saveRDS(res, paste0("analysis_out/",tr_name,"_",mod,".rds"))
