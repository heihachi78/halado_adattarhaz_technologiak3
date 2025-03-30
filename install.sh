#!/bin/bash

git clone https://github.com/heihachi78/pemik_adatbazis_beadando3.git tdb
cd tdb
${PWD}/install.sh
cd ..
./setup_docker.sh
./setup_db.sh
./setup_airbyte.sh
./setup_python.sh
./show_info.sh

prefect server start
