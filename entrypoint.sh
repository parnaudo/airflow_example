#!/usr/bin/env bash

set -ex

# We use Dockerfile to put this in the ~/.bashrc now:
#aws configure set default.region us-east-1

# Run this once, for a new database:
# airflow db init
# cd /airflow/dataplatform/airflow/
# bin/sync_git.sh 

echo "starting airflow scheduler *********"
airflow scheduler &

echo "starting airflow webserver"
airflow webserver --port 8080

