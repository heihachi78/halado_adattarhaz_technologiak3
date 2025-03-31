#!/bin/bash

echo "uninstalling..."

docker stop dwhdb
docker rm dwhdb
docker stop prefsrv
docker rm prefsrv

cd tdb
${PWD}/uninstall.sh
cd ..
rm -rf ${PWD}/tdb
echo "uninstall done"

abctl local uninstall --persisted
rm -rf ~/.airbyte
rm -rf ${PWD}/.venv
rm -f ${PWD}/prefect/flows/cred.json
