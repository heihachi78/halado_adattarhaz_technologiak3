#!/bin/bash

echo "uninstalling..."

docker stop dwhdb
docker rm dwhdb

cd tdb
${PWD}/uninstall.sh
cd ..
rm -rf ${PWD}/tdb
echo "uninstall done"

abctl local uninstall --persisted
rm -rf ~/.airbyte
rm -rf ${PWD}/.venv
