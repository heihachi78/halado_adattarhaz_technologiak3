#!/bin/bash

echo "uninstalling..."

cd tdb
${PWD}/uninstall.sh
cd ..

docker stop dwhdb
docker rm dwhdb
docker stop prefsrv
docker rm prefsrv
docker stop metabase
docker rm metabase

abctl local uninstall --persisted

rm -rf ${PWD}/tdb
rm -rf ~/.airbyte
rm -rf ${PWD}/.venv
rm -f ${PWD}/prefect/flows/cred.json

docker network rm postgresnet

echo "uninstall done"
