#!/usr/bin/env

"""
Helper scripts to load the data inside `data` folder to BigQuery
For idempotent property, we first remove the data of specific partition and fund before we load data there
This is direct local load to BigQuery, definitely not the best practice

For bigger data, we should probably move that to GCS before load to BQ. But the data size for this project is small
Direct load is fine and easier

Usage:
    python3 bq_load.py --date 2021-02-19 --file ARKF.csv

    --date: partition date, follow YYYY-MM-DD, should match the date in data
    --file: file name, follow CODE.csv, CODE should be one of the ARK fund codes
"""

from google.cloud import bigquery
import argparse

FUND_CODE_TO_UPLOAD = ["ARKF", "ARKG", "ARKK", "ARKQ", "ARKW", "IZRL", "PRNT"] 

parser = argparse.ArgumentParser()
parser.add_argument("--date", "-d", help="file date YYYY-MM-DD, eg: 2021-02-19, match with date in data")
parser.add_argument("--file", "-f", help="file name, eg: ARFK.csv")
args = parser.parse_args()

# get the partition_date, eg: 2021-02-19
if args.date:
    partition_date = args.date
    assert len(partition_date)==10
    assert len(partition_date.split("-"))==3
    assert tuple(map(len, partition_date.split("-")))==tuple([4, 2, 2])

# get the fund code, eg: ARKK
if args.file:
    file_name = args.file
    code, file_format = file_name.split(".")
    assert code in FUND_CODE_TO_UPLOAD
    assert file_format=="csv"

# Construct a BigQuery client object.
client = bigquery.Client()
table_id = "ark-track.raw.test"


###########
# Remove the data first, avoid duplication
###########
dml_statement = """
DELETE FROM `{table_id}`
WHERE date="{partition_date}" and fund="{fund}"
""".format(table_id=table_id, partition_date=partition_date, fund=code)
query_job = client.query(dml_statement)  # API request
query_job.result()  # Waits for statement to finish
print(
    "Removed data on {} and fund {} in {}".format(
        partition_date, code, table_id
    )
)

###########
# Add the data to corresponding partition
###########
file_path = "../data/{partition_date}/{file_name}".format(partition_date=partition_date, file_name=file_name)
job_config = bigquery.LoadJobConfig(
    source_format=bigquery.SourceFormat.CSV, skip_leading_rows=1, autodetect=False,
)

with open(file_path, "rb") as source_file:
    job = client.load_table_from_file(source_file, table_id, job_config=job_config)

job.result()  # Waits for the job to complete.

table = client.get_table(table_id)  # Make an API request.
print(
    "Loaded data to {} on {} for {}".format(
        table_id, partition_date, code
    )
)
