library(ape)
library(MMCTime)

set.seed(1243678)

set_size <- 48
samp_t <- 4:1
n_d <- length(samp_t)
n_tip <- 200

nu <- 1/10

alphas <-seq(from=0.01, to=.75, length.out=set_size)
phis <- c(0.0, 0.5, 0.75, 1.0)

k <- 1
for(i in 1:4)
{
    for(j in 1:set_size)
    {
        n_samp <- rmultinom(1, size=n_tip, prob=rep(1,n_d)/n_d)[,1]
        stopifnot(sum(n_samp) == n_tip)
        sim <- simulate_km_beta(samp_t, n_samp, phis[i], nu, alphas[j])
        write.tree(sim$phy, paste0("tree_",k,".nwk"))
        write.table(sim$dates, paste0("dates_",k,".tab"))
        k <- k+1
    }
}


