## USEFUL INFOS

### PREFECT
http://localhost:4200

### METABASE
http://localhost:3000
user: pemik@bead.hu
pass: pass19

### PGADMIN
http://localhost:8080
user: beadando@pemik.hu
pass: pass

### AIRBYTE
http://localhost:8000
user: pemik@bead.hu
org: bead
pass: pass

### IP ADDRESSES
srv1: 172.21.0.2
dwhdb: 172.21.0.7

### PORT MAPPINGS
srv1: 5432->5431
dwhdb: 5432->5454

### DB PASSWORDS
postgres/pass
cms/pass
dwh/pass
airbyte/pass
dbt/pass

## AIRFLOW SETUP

### SOURCE
connector: Postgres
name: Postgres SRV1
host: host.docker.internal
port: 5431
database: cms
username: airbyte
password: pass
replication slot: airbyte_slot
publication: airbyte_publication
heartbeat SQL: INSERT INTO airbyte_heartbeat (text) VALUES ('heartbeat')
invalid CDC behaviour: re-sync data

### DESTINATION
connector: Postgres
name: Postgres DWHDB
host: host.docker.internal
port: 5454
database: dwh
schema: staging
user: airbyte
password: pass
