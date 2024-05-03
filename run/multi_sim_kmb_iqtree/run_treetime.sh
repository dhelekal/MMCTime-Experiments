mkdir $1/tree_$2
rm $1/tree_$2/*

Rscript ../ana_tre_treetime.R $1/tree_$2/ $2