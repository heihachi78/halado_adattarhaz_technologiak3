#!/bin/bash

echo "uninstalling..."

cd tdb
${PWD}/uninstall.sh
cd ..

docker stop dwhdb
docker rm dwhdb
docker volume rm dwhdbdata
docker stop prefsrv
docker rm prefsrv
docker stop metabase
docker rm metabase

rm -rf ${PWD}/tdb
rm -rf ${PWD}/.venv
rm -f ${PWD}/prefect/flows/cred.json

docker network rm postgresnet

echo "uninstall done"
