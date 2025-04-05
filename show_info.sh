
#!/bin/bash

SRV1_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' srv1)
DWHDB_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dwhdb)
PREFECT_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' prefsrv)


echo "IP ADDRESSES"
echo "srv1 : $SRV1_IP"
echo "dwhdb : $DWHDB_IP"
echo "prefect : $PREFECT_IP"

echo "PORT MAPPINGS"
echo "srv1 : 5432->5431"
echo "dwhdb : 5432->5454"

echo "DB PASSWORDS"
echo "postgres/pass"
echo "cms/pass"
echo "dwh/pass"
echo "meltano/pass"

echo ""
echo "Prefect dashboard: http://localhost:4200"
echo "dbt docs: http://localhost:8082"
echo "PgAdmin: http://localhost:8080"
echo "Metabase: http://localhost:3000"
echo "creds: pemik@bead.hu/pass19"
