#!/bin/bash

# helper script to load data to BQ
dates=$(ls ../data)
codes=("ARKF" "ARFG" "ARKK" "ARKQ" "ARKW" "IZRL" "PRNT" "ARKX")

for date in ${dates[@]}; do
  for code in ${codes[@]}; do
    python3 bq_load.py --date $date --file $code.csv
  done
done
