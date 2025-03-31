#!/bin/bash

curl -LsfS https://get.airbyte.com | bash -
abctl local install
abctl local credentials --email pemik@bead.hu
abctl local credentials --password pass

docker network connect postgresnet airbyte-abctl-control-plane
