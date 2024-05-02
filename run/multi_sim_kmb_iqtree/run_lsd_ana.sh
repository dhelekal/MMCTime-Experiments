#!/bin/bash
cd $1

mkdir ana_lsd
rm ./ana_lsd/*

echo "starting lsd analysis"

parallel --delay .2 -j 12 Rscript ../ana_tre_lsd2.R ana_lsd {1} ::: {1..144}

