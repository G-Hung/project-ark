#!/bin/bash

# script that extract and transform the data from ARK fund for listed funds
# Then load use `bq_load.py` to load the data to BigQuery

# list of funds that we track
files=("ARK_INNOVATION_ETF_ARKK_HOLDINGS" "ARK_AUTONOMOUS_TECHNOLOGY_&_ROBOTICS_ETF_ARKQ_HOLDINGS" "ARK_NEXT_GENERATION_INTERNET_ETF_ARKW_HOLDINGS" "ARK_GENOMIC_REVOLUTION_MULTISECTOR_ETF_ARKG_HOLDINGS" "ARK_FINTECH_INNOVATION_ETF_ARKF_HOLDINGS" "THE_3D_PRINTING_ETF_PRNT_HOLDINGS" "ARK_ISRAEL_INNOVATIVE_TECHNOLOGY_ETF_IZRL_HOLDINGS" "ARK_SPACE_EXPLORATION_&_INNOVATION_ETF_ARKX_HOLDINGS")

# initialize the tmp subfolder
mkdir -p data/tmp
cd data

# for each file, extract, clean and move to corresponding position
# https://stackoverflow.com/questions/428109/extract-substring-in-bash
for file in ${files[@]}; do
  # extract the code from string
  # eg: ARK_INNOVATION_ETF_ARKK_HOLDINGS => ARKK
  code=$(echo $file| rev | cut -d'_' -f 2 | rev)
  echo $code

  # download csv from ark-funds.com and remove the last 4 lines <- The last 3 rows of original csv contain some text, not the data
  # For Linux
  curl -A "Mozilla/6.0" https://ark-funds.com/wp-content/fundsiteliterature/csv/$file.csv | tac | sed '1,3d' | tac > tmp/$code.csv
  # For Mac
  # curl https://ark-funds.com/wp-content/fundsiteliterature/csv/$file.csv | tail -r | sed '1,3d' | tail -r > tmp/$code.csv

  # date format conversion, eg: 2/19/2021 to 2021-02-09
  # Go to row 2 col 1 [aka first date], extract year month day component
  year=$(awk "NR==2" tmp/$code.csv | cut -d',' -f 1 | cut -d'/' -f 3 | awk '{printf "%04d\n", $0;}')
  month=$(awk "NR==2" tmp/$code.csv | cut -d',' -f 1 | cut -d'/' -f 1 | awk '{printf "%02d\n", $0;}')
  day=$(awk "NR==2" tmp/$code.csv | cut -d',' -f 1 | cut -d'/' -f 2 | awk '{printf "%02d\n", $0;}')
  date=$year-$month-$day
  echo "partition: "$date
  mkdir -p $date
  # replace first col of csv of formatted date, because direct load to BQ requires YYYY-MM-DD format
  # https://stackoverflow.com/questions/59548775/bigquery-fails-on-parsing-dates-in-m-d-yyyy-format-from-csv-file
  # https://stackoverflow.com/questions/22003995/replacing-first-column-csv-with-variable
  awk -v dt="$date" 'BEGIN{FS=OFS=","}{$1=dt}1' tmp/$code.csv | sed "1s/$date/date/" > $date/$code.csv
  pwd
  python3 ../scripts/bq_load.py --date $date --file $code.csv
done

rm tmp/*
