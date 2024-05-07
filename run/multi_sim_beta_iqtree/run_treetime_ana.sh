#!/bin/bash
cd $1

mkdir ana_treetime
rm -r ./ana_treetime/*

echo "starting treetime analysis"

parallel --delay .2 -j 12 sh ../run_treetime.sh ana_treetime {1} ::: {1..144}

