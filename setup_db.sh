#!/bin/bash

#echo "*:*:*:meltano:pass" >> ${PWD}/tdb/srv1/mnt/config/.pgpass 

docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "CREATE USER meltano;"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "alter user meltano with password 'pass';"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "ALTER USER meltano REPLICATION;"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "GRANT CONNECT ON DATABASE cms TO meltano;"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "GRANT USAGE ON SCHEMA public TO meltano;"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO meltano;"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "CREATE TABLE public.meltano_heartbeat (id SERIAL PRIMARY KEY, timestamp TIMESTAMP NOT NULL DEFAULT current_timestamp, text TEXT);"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "GRANT ALL ON public.meltano_heartbeat TO meltano;"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "GRANT USAGE, SELECT ON SEQUENCE public.meltano_heartbeat_id_seq TO meltano;"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO meltano;"
docker exec -u postgres srv1 psql -p 5432 -U meltano -d cms -t -c "SELECT pg_create_logical_replication_slot('meltano_slot', 'wal2json');"
docker exec -u postgres srv1 psql -p 5432 -U cms -d cms -t -c "CREATE PUBLICATION meltano_publication FOR ALL TABLES;"

docker exec -u postgres dwhdb createuser -s dwh
docker exec -u postgres dwhdb createdb dwh -O dwh
docker exec -u postgres dwhdb psql -p 5432 -U postgres -d postgres -t -c "alter user dwh with password 'pass';"
docker exec -u postgres dwhdb psql -p 5432 -U dwh -d dwh -t -c "create schema if not exists staging;"

docker exec -u postgres dwhdb psql -p 5432 -U dwh -d dwh -t -c "CREATE USER meltano WITH PASSWORD 'pass';"
docker exec -u postgres dwhdb psql -p 5432 -U dwh -d dwh -t -c "GRANT ALL ON DATABASE dwh TO meltano;" #connect, create scheme, temp
docker exec -u postgres dwhdb psql -p 5432 -U dwh -d dwh -t -c "GRANT ALL ON SCHEMA staging TO meltano;" #usage, create table
docker exec -u postgres dwhdb psql -p 5432 -U dwh -d dwh -t -c "ALTER DEFAULT PRIVILEGES IN SCHEMA staging GRANT ALL ON TABLES TO meltano;" #all...
