library(MMCTime)

args <- commandArgs(TRUE)
print(args)
if (length(args)!=1) {
  stop("Need 1 arguments.", call.=FALSE)
}

res <- readRDS(args[1])
if (class(res) == "timingRes")
{
  res$names_par_obs[res$names_par_obs=="sigma"]<-"omega"

  cn <- colnames(res$draws)
  cn[cn=="sigma"] <- "omega"

  colnames(res$draws) <- cn
  res$summaries <- within(res$summaries, variable[variable=="sigma"] <- "omega")

  saveRDS(res,args[1])
}

