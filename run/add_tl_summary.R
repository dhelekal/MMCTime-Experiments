library(MMCTime)
library(ape)
library(posterior)

args <- commandArgs(TRUE)
print(args)
if (length(args)!=1) {
  stop("Need 1 arguments.", call.=FALSE)
}

sample2tree <- function(x, s_idx)
{
    m <- length(x$undated$tip.label)
    n <- 2*m-1

    tiplabs <- x$undated$tip.label
    edge <- matrix(-1L, n, 2)

    time_cols <- paste0("t_", 1:n)
    pa_cols <- paste0("pa_", 1:n)

    ts <- suppressWarnings(unlist(x$draws[s_idx, time_cols]))
    pas <- suppressWarnings(unlist(x$draws[s_idx, pa_cols]))

    edge[,2] <- 1L:n
    edge[,1] <- pas
    edge <- edge[-which(is.na(edge[,1])),]

    elen <- sapply(1:(n-1), function(i) abs(ts[edge[i,1]] - ts[edge[i,2]]))

    tr <- list(edge=edge, edge.length=elen, Nnode=m-1L, tip.label=tiplabs)
    class(tr) <- "phylo"

    return(tr)
}

res <- readRDS(args[1])
if (class(res) == "timingRes")
{
  res$draws$tree_length <- sapply(1:res$n_draws, function(i) sum(sample2tree(res, i)$edge.length))
  root_n <- length(res$undated$tip.label) + 1
  s <- summarise_draws(res$draws)
  s <- s[s$variable %in% c(paste0("t_", root_n), res$names_par_obs, res$names_par_tree, res$names_summaries, "tree_length"), ]
  res$summaries <- s
  saveRDS(res, args[1])
}

