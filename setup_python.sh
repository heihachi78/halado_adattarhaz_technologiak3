#!/bin/bash

python3 -m venv .venv
while ! test -f "${PWD}/.venv/bin/activate"; do
    echo "waiting for python virtual environment to be created..."
    sleep 1
done
source .venv/bin/activate
echo "changed to virtual environment .venv"
python3 -m pip install --upgrade pip
python3 -m pip install dbt-core dbt-postgres
python3 -m pip install -U prefect
python3 -m pip install prefect-airbyte
python3 -m pip install "prefect[docker]"

cd dbt_transform
dbt deps
dbt debug
cd ..

cd prefect/flows
python create_cred.py
cd ..
cd ..
