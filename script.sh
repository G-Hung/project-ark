files=("ARK_INNOVATION_ETF_ARKK_HOLDINGS" "ARK_AUTONOMOUS_TECHNOLOGY_&_ROBOTICS_ETF_ARKQ_HOLDINGS" "ARK_NEXT_GENERATION_INTERNET_ETF_ARKW_HOLDINGS" "ARK_GENOMIC_REVOLUTION_MULTISECTOR_ETF_ARKG_HOLDINGS" "ARK_FINTECH_INNOVATION_ETF_ARKF_HOLDINGS" "THE_3D_PRINTING_ETF_PRNT_HOLDINGS" "ARK_ISRAEL_INNOVATIVE_TECHNOLOGY_ETF_IZRL_HOLDINGS")

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
  # download csv from ark-funds.com and remove the last 4 lines
  curl https://ark-funds.com/wp-content/fundsiteliterature/csv/$file.csv | tail -r | sed '1,4d' | tail -r > tmp/$code.csv
  # date format conversion, eg: 2/19/2021 to 2021-02-09
  # Go to row 2 col 1 [aka first date], extract year month day component
  year=$(awk "NR==2" tmp/$code.csv | cut -d',' -f 1 | cut -d'/' -f 3 | awk '{printf "%04d\n", $0;}')
  month=$(awk "NR==2" tmp/$code.csv | cut -d',' -f 1 | cut -d'/' -f 1 | awk '{printf "%02d\n", $0;}')
  day=$(awk "NR==2" tmp/$code.csv | cut -d',' -f 1 | cut -d'/' -f 2 | awk '{printf "%02d\n", $0;}')

  date=$year-$month-$day
  echo "partition: "$date
  pwd
  mkdir -p $date
  mv tmp/$code.csv $date/$code.csv

done