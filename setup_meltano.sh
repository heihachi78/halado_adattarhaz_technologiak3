#!/bin/bash

docker exec prefsrv sh -c "cd /mnt/flows && hap run python meltano_flow.py"
docker exec prefsrv sh -c "cd /mnt/meltano/pemik-dwh && meltano install"
docker exec prefsrv sh -c "cd /mnt/meltano/pemik-dwh && meltano lock --update --all"
docker exec prefsrv sh -c "cd /mnt/meltano/pemik-dwh && hap run meltano run srv1-extract dwhdb-load --no-state-update --full-refresh"
