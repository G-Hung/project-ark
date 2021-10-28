###############
# Get from others in case our repo down, iterate the git commit id, get commit -d by `git log --oneline`
###############
cd holdings
commits=("90f6aa7" "341a3f6" "4b103ae" "6f976b8" "e77d55e" "7672243" "9f35641" "b49f26a" "6c5da79")
tickers=("ARKK" "ARKQ" "ARKW" "ARKG" "ARKF" "PRNT" "IZRL" "ARKX")

for commit in ${commits[@]}; do
    git checkout ${commit}
    for ticker in ${tickers[@]}; do
        cat ARK_INNOVATION_ETF_${ticker}_HOLDINGS.csv | tail -r | sed '1,3d' | tail -r > tmp/${ticker}_${commit}.csv
    done
done

###############
# Copy the data to this repo under `data/tmp`
###############
# Assume all backup csv are under data/tmp
# initialize the tmp subfolder
cd data/tmp
# cd data

for filename in *.csv; do
    code=$(echo $filename| rev | cut -d'_' -f 2 | rev)
    echo $filename

    year=$(awk "NR==2" $filename | cut -d',' -f 1 | cut -d'/' -f 3 | awk '{printf "%04d\n", $0;}')
    month=$(awk "NR==2" $filename | cut -d',' -f 1 | cut -d'/' -f 1 | awk '{printf "%02d\n", $0;}')
    day=$(awk "NR==2" $filename | cut -d',' -f 1 | cut -d'/' -f 2 | awk '{printf "%02d\n", $0;}')
    date=$year-$month-$day

    echo "partition: "$date
    mkdir -p $date
    awk -v dt="$date" 'BEGIN{FS=OFS=","}{$1=dt}1' $filename | sed "1s/$date/date/" > $date/$code.csv
    pwd
    python3 ../../scripts/bq_load.py --date $date --file $code.csv    
done
