#!/bin/bash

docker exec prefsrv sh -c "cd /mnt/flows && hap run python meltano_flow.py"
docker exec prefsrv sh -c "cd /mnt/meltano/pemik-dwh && meltano install"
docker exec prefsrv sh -c "cd /mnt/meltano/pemik-dwh && meltano lock --update --all"
docker exec prefsrv sh -c "cd /mnt/meltano/pemik-dwh && hap run meltano run srv1-extract dwhdb-load --no-state-update --full-refresh"
docker exec prefsrv sh -c "cd /mnt/meltano/pemik-dwh && hap run meltano invoke dbt-postgres:docs-generate"
docker exec prefsrv sh -c "cd /mnt/meltano/pemik-dwh && hap run meltano invoke dbt-postgres:docs-serve --host 0.0.0.0 --port 8080"
