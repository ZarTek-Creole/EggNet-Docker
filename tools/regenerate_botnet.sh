#!/bin/bash
TMP_PWD=$(pwd)
cd ..
docker-compose stop
docker-compose down
rm -rf EggNet_DATADIR/secrets
rm -rf EggNet_DATADIR/logs
rm -rf EggNet_DATADIR/files
rm -rf EggNet_DATADIR/conf
docker-compose up -d --build --remove-orphans
docker-compose ps
cd ${TMP_PWD}
