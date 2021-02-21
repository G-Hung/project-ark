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

## Lesson learnt
When I tried to use GitHub Actions to push the data to GCP BigQuery, one thing made me super panic! My Google Service Account json was committed to my repo despite I stored it in my GitHub Secrets! I literally shared all the credentials to everyone who can read the repo! WTF is going on!?!? 

1. My first guess is I copied the plain JSON to GitHub Secrets and somehow it leaks during the progress?

2. Hmmm I rmb people said the key should be base64, ok, let me try it by using `cat key.json | base64`, and then copy that to GitHub Secrets. But GitHub Actions still created a commit to show all my secrets........

3. I notice the secret file name is similar to hash [no meaning, random strings] and secrets are committed by GitHub Actions step, that is responsible for pushing the new data to my repo, somehow other than data, it finds a file that contains my secrets???

4. At last, my solution is: change `git add -A` to `git add data`. My guess is, GitHub Actions somehow create a file for the steps to access the secrets, normally we will not know the file name because it is randomly generated. BUT they may not expect some people have a step to git push all the files, including the secrets!!!

5. The reason why I used `git add -A` is, I literally copied it from other repo, it is nice for their cases because they don't use Google Cloud and need to handle the credentials, a big lesson that we should be specific about everything, don't apply actions to ALL without really knowing all the consequences!
