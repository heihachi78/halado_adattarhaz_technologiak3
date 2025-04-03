#!/bin/bash

python3 -m venv .venv
while ! test -f "${PWD}/.venv/bin/activate"; do
    echo "waiting for python virtual environment to be created..."
    sleep 1
done
source .venv/bin/activate
echo "changed to virtual environment .venv"
python3 -m pip install -q --upgrade pip
python3 -m pip install -q dbt-core dbt-postgres
python3 -m pip install -q -U prefect
python3 -m pip install -q -U --pre prefect-dbt
python3 -m pip install -q -U "prefect[shell]"

docker exec prefsrv sh -c "cd /mnt/flows && hap run python meltano_flow.py"
docker exec prefsrv sh -c "cd /mnt/meltano/pemik-dwh && meltano install"
docker exec prefsrv sh -c "cd /mnt/meltano/pemik-dwh && meltano lock --update --all"
docker exec prefsrv sh -c "cd /mnt/meltano/pemik-dwh && hap run meltano run srv1-extract dwhdb-load --no-state-update --full-refresh"
