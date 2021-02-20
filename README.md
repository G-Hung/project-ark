# project-ARK

## Purpose
This is my side project for the famous ARK funds https://ark-funds.com/ :) ARK funds are transparent enough to show their holdings daily.

But I am more curious about the **CHANGES**, for example:

- which companies are included recently?
- which companies are removed recently?
- how do the weights change?
- etc etc

To see the current snapshot is easy, just go to their site! But to see the changes and have more analyses based on the current snapshot alone is more challenging. So, this project exists :)

## Project plans

1. **[Extract]** Scraping script to extract and clean the snapshot from site daily using `GitHub Actions`
2. **[Load]** Load data to data warehouse, maybe `BigQuery`?
3. **[Quality]** Write some data testings using `dbt`
4. **[Analysis]** Have some analytic queries in `dbt` plus some visualization maybe

##### Maybe, maybe not
5. **[Visualization]** interactive data visualization site
6. **[Subscription]** subscribe the changes and send myself a summary email


