#!/bin/bash

docker run \
    --net postgresnet \
    --name dwhdb \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=pass \
    -e POSTGRES_DB=postgres \
    -e PGDATA="/mnt/data" \
    -e PGPASSFILE="/mnt/config/.pgpass" \
    -p 5454:5432 \
    -v ${PWD}/dwhdb/mnt/config:/mnt/config \
    -d pgs \
    -c "config_file=/mnt/config/postgresql.conf"

docker exec -u postgres dwhdb bash -c "cd ~ && cp /mnt/config/.pgpass . && chmod 0600 .pgpass && chmod 0600 /mnt/config/.pgpass"

while true; do
    row_count=$(docker exec -u postgres dwhdb psql -p 5432 -U postgres -d postgres -t -c "select 1" 2>/dev/null | xargs)
    if [ -n "$row_count" ]
    then
        if [ "$row_count" -gt 0 ]; then
          break
        fi
    else
        echo "waiting for dwhdb to start..."
        sleep 1
    fi
done
