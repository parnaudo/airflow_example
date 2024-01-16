# -*- coding: utf-8 -*-

# Run a VACUUM job on Redshift to clean up and improve performance.
# We do this daily using the `amazon-redshift-utils` package.

import os
from airflow.models import DAG
from airflow.operators.python_operator import PythonOperator
from util import aws
from common.common import ENV, dag_default_args, short_filename
from jinja2 import Template

def show_me_airflow() -> None:
    print("Hi There Kibeam")



with DAG(dag_id='helloworld',  #hello_world
         default_args=dag_default_args,
         schedule_interval='*/10 * * * *',
         catchup=False) as dag:
    task = PythonOperator(task_id='preprocessing',
                                python_callable=show_me_airflow)
    bluriness_task = PythonOperator(task_id='bluriness_processing',
                                python_callable=show_me_airflow)
    brightness_task = PythonOperator(task_id='brightness_processing',
                                python_callable=show_me_airflow)
    # embed_task = GPUOperator(task_id='brightness_processing',
    #                             python_callable=show_me_airflow)
    end_op =  PythonOperator(task_id='end_op',
                                python_callable=show_me_airflow)
    task  << bluriness_task
    task << brightness_task
    # task << embed_processing
    end_op >>  bluriness_task
    end_op >> brightness_task

    # task = AWSBatchOperator(task_id='run_print',
    #                             python_callable=show_me_airflow
    #                             task_variables = data[instance = 1,
    #                                                   instance_type = 'GPU AWS instance',

    #                                                   ]
    #                             )  

if __name__ == "__main__":
    show_me_airflow(None)
