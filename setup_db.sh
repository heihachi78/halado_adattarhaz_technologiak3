#!/bin/bash

echo "*:*:*:airbyte:pass" >> ${PWD}/tdb/srv1/mnt/config/.pgpass 

docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "CREATE USER airbyte;"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "alter user airbyte with password 'pass';"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "ALTER USER airbyte REPLICATION;"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "GRANT CONNECT ON DATABASE cms TO airbyte;"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "GRANT USAGE ON SCHEMA public TO airbyte;"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO airbyte;"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "CREATE TABLE public.airbyte_heartbeat (id SERIAL PRIMARY KEY, timestamp TIMESTAMP NOT NULL DEFAULT current_timestamp, text TEXT);"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "GRANT ALL ON public.airbyte_heartbeat TO airbyte;"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "GRANT USAGE, SELECT ON SEQUENCE public.airbyte_heartbeat_id_seq TO airbyte;"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO airbyte;"
docker exec -u postgres srv1 psql -p 5432 -U airbyte -d cms -t -c "SELECT pg_create_logical_replication_slot('airbyte_slot', 'pgoutput');"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "CREATE PUBLICATION airbyte_publication FOR ALL TABLES;"

docker exec -u postgres dwhdb createuser -s dwh
docker exec -u postgres dwhdb createdb dwh -O dwh
docker exec -u postgres dwhdb psql -p 5432 -U postgres -d postgres -t -c "alter user dwh with password 'pass';"
docker exec -u postgres dwhdb psql -p 5432 -U dwh -d dwh -t -c "create schema if not exists staging;"
docker exec -u postgres dwhdb psql -p 5432 -U dwh -d dwh -t -c "CREATE USER airbyte WITH PASSWORD 'pass';"

docker exec -u postgres dwhdb psql -p 5432 -U dwh -d dwh -t -c "GRANT CONNECT ON DATABASE dwh TO airbyte;"
docker exec -u postgres dwhdb psql -p 5432 -U dwh -d dwh -t -c "GRANT ALL ON DATABASE dwh TO airbyte;"
docker exec -u postgres dwhdb psql -p 5432 -U dwh -d dwh -t -c "GRANT USAGE ON SCHEMA staging TO airbyte;"
docker exec -u postgres dwhdb psql -p 5432 -U dwh -d dwh -t -c "GRANT ALL ON SCHEMA staging TO airbyte;"

docker exec -u postgres dwhdb psql -p 5432 -U dwh -d dwh -t -c "CREATE USER dbt WITH PASSWORD 'pass';"
docker exec -u postgres dwhdb psql -p 5432 -U dwh -d dwh -t -c "GRANT CONNECT ON DATABASE dwh TO dbt;"
docker exec -u postgres dwhdb psql -p 5432 -U dwh -d dwh -t -c "GRANT ALL ON DATABASE dwh TO dbt;"
docker exec -u postgres dwhdb psql -p 5432 -U dwh -d dwh -t -c "GRANT USAGE ON SCHEMA staging TO dbt;"
docker exec -u postgres dwhdb psql -p 5432 -U dwh -d dwh -t -c "GRANT USAGE ON SCHEMA public TO dbt;"
docker exec -u postgres dwhdb psql -p 5432 -U dwh -d dwh -t -c "GRANT ALL ON SCHEMA staging TO dbt;"
docker exec -u postgres dwhdb psql -p 5432 -U dwh -d dwh -t -c "GRANT ALL ON SCHEMA public TO dbt;"
docker exec -u postgres dwhdb psql -p 5432 -U dwh -d dwh -t -c "GRANT SELECT ON ALL TABLES IN SCHEMA staging TO dbt;"
