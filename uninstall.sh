#!/bin/bash

echo "uninstalling..."

docker stop dwhdb
docker rm dwhdb
docker stop prefsrv
docker rm prefsrv

cd tdb
${PWD}/uninstall.sh
cd ..

abctl local uninstall --persisted

rm -rf ${PWD}/tdb
rm -rf ~/.airbyte
rm -rf ${PWD}/.venv
rm -f ${PWD}/prefect/flows/cred.json

docker network rm postgresnet

echo "uninstall done"
