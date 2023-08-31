library(MMCTime)

args <- commandArgs(TRUE)
print(args)
if (length(args)!=1) {
  stop("Need 1 arguments.", call.=FALSE)
}

res <- readRDS(args[1])

cn <- colnames(res$draws)
cn[cn=="sigma"] <- "omega"

colnames(res$draws) <- cn
within(res$summaries, variable[variable=="sigma"] <- "omega")

saveRDS(res)
