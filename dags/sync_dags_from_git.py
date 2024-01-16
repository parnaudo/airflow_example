# -*- coding: utf-8 -*-

# This task will pull the latest dags from Github.
# I.e. poor man's continuous deployment.

from __future__ import print_function
import datetime
from airflow.models import DAG, Variable
from airflow.operators.bash_operator import BashOperator
from common.common import dag_default_args, path_rel
import os
import sqlalchemy


default_vars = dict(branch='')
try:
    dag_vars = dict(Variable.get(os.path.basename(__file__).split(".")[0],
                                 default_var=default_vars,
                                 deserialize_json=True))
except sqlalchemy.exc.OperationalError:
    print("Couldn't reach Airflow variables.")
    dag_vars = default_vars
finally:
    print(f"Sync from git branch {dag_vars['branch']}.")
    branch = dag_vars["branch"]


dag = DAG(
    dag_id='sync_dags_from_git',
    default_args=dag_default_args,
    max_active_runs=1,
    catchup=False,
    schedule_interval=datetime.timedelta(minutes=60),
    start_date=datetime.datetime(2018, 12, 10)
)


sync_dags = BashOperator(
    task_id='sync_git',
    # Note: ensure bash_command value ends in a space, to avoid it being treated
    # as a Template (see https://cwiki.apache.org/confluence/display/AIRFLOW/Common+Pitfalls)
    bash_command=path_rel(__file__, '../bin/sync_git.sh') + f' {branch} ',
    dag=dag
)
# context['dag_run'].conf['key']
