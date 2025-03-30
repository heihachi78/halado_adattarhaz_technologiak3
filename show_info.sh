
#!/bin/bash

SRV1_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' srv1)
DWHDB_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dwhdb)

echo "IP ADDRESSES"
echo "srv1 : $SRV1_IP"
echo "dwhdb : $DWHDB_IP"

echo "PORT MAPPINGS"
echo "srv1 : 5432->5431"
echo "dwhdb : 5432->5454"

echo "DB PASSWORDS"
echo "postgres/pass"
echo "cms/pass"
echo "dwh/pass"
echo "airbyte/pass"

abctl local credentials
abctl local status
