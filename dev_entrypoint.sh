#!/usr/bin/env bash

set -ex

# Set db connection to local mysql container and disable AWS RDS connection.
export AIRFLOW__CORE__SQL_ALCHEMY_CONN="mysql://admin:admin@db:3306/airflow?charset=utf8mb4"
export AIRFLOW__CORE__SQL_ALCHEMY_CONN_CMD=""

# so airflow cools it with the local CPU
export AIRFLOW__SCHEDULER__MIN_FILE_PROCESS_INTERVAL="60"

sleep 30

echo "initializing airflow database"
airflow db init

echo "Creating airflow user"
airflow users create --role Admin --username admin --firstname airflow --lastname user --email airflow@airflow.com --password admin

echo "starting airflow scheduler"
airflow scheduler &

echo "starting airflow webserver"
airflow webserver --port 8080
