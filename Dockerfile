FROM python:3.7-buster

# Never prompt the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Airflow
ARG AIRFLOW_VERSION=2.2.4
ARG AIRFLOW_USER_HOME=/airflow
ARG AIRFLOW_DEPS=""
ARG PYTHON_DEPS=""
ENV AIRFLOW_HOME=${AIRFLOW_USER_HOME}

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8

# Disable noisy "Handling signal" log messages:
# ENV GUNICORN_CMD_ARGS --log-level WARNING

# Install requirements for adding chrome repo and Gecko driver
RUN apt-get update -yqq \
        && apt-get install -y wget gnupg2

# Install packages and library dependencies
RUN apt-get update -yqq \
            && apt-get upgrade -yqq \
            && apt-get install -yqq --no-install-recommends \
            freetds-dev \
            libkrb5-dev \
        libsasl2-dev \
            libssl-dev \
            libffi-dev \
            libpq-dev \
            git \
            libhdf5-serial-dev \
            postgresql-client \
            groff \
            libatlas-base-dev \
            libmariadbclient-dev \
            pipenv \
            freetds-bin \
            build-essential \
            default-libmysqlclient-dev \
            apt-utils \
            curl \
            rsync \
            netcat \
            locales 


# Cleanup package leftovers
RUN apt-get purge --auto-remove -yqq $buildDeps \
            && apt-get autoremove -yqq --purge \
            && apt-get clean \
            && rm -rf \
            /var/lib/apt/lists/* \
            /tmp/* \
            /var/tmp/* \
            /usr/share/man \
            /usr/share/doc \
            /usr/share/doc-base

# Configure locale
RUN sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
            && locale-gen \
            && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

WORKDIR ${AIRFLOW_USER_HOME}

COPY requirements.txt ${AIRFLOW_USER_HOME}/requirements.txt

COPY entrypoint.sh /entrypoint.sh
COPY airflow.cfg ${AIRFLOW_HOME}/airflow.cfg
COPY webserver_config.py ${AIRFLOW_HOME}/webserver_config.py
#default region for awscli
ENV AWS_DEFAULT_REGION=us-east-1
ENV ENV=production
# Install airflow and pip requirements
RUN pip install -r requirements.txt
RUN mkdir /var/log/airflow
# Add airflow user
RUN useradd -ms /bin/bash -d ${AIRFLOW_USER_HOME} airflow

# Set ownership to airflow user
RUN chown -R airflow: ${AIRFLOW_HOME}
RUN chown -R airflow: /var/log/airflow

EXPOSE 8080 5555 8793

USER airflow

CMD ["/entrypoint.sh"]

