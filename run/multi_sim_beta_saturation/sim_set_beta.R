library(ape)
library(MMCTime)

set.seed(9243735)

set_size <- 48L*3L
samp_t <- 4:1
n_d <- length(samp_t)
n_tip <- 200

nu <- 1/10

alphas <-seq(from=.01, to=.99, length.out=set_size)

for(i in 1:set_size)
{
    n_samp <- rmultinom(1, size=n_tip, prob=rep(1,n_d)/n_d)[,1]
    stopifnot(sum(n_samp) == n_tip)
    sim <- simulate_beta(samp_t, n_samp, nu, alphas[i])
    write.tree(sim$phy, paste0("tree_",i,".nwk"))
    write.table(sim$dates, paste0("dates_",i,".tab"))
}



