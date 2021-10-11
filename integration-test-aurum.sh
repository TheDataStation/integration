#!/bin/bash -ex

# this needs to build separately from docker compose because it needs
# to be built before its users components, and it doesn't look like
# build order can be specified in docker compose (just startup order?)
pushd ../aurum-common
docker build --tag=aurum/aurum-common .
popd

docker-compose -f ./docker-compose.aurum.yaml build
docker-compose -f ./docker-compose.aurum.yaml build profiler
docker-compose -f ./docker-compose.aurum.yaml build nbc

docker-compose -f ./docker-compose.aurum.yaml up --abort-on-container-exit &
services_pid=$!


# TODO might need to wait for the relevant containers to be up?
# fake this for now with a sleep
sleep 60s

# TODO: prep adventurework into /data mountpoint

# Import adventurework dataset:
# First run ddprofiler
# Second run nbc

docker-compose -f ./docker-compose.aurum.yaml run profiler
echo Exit code from profiler: $?

docker-compose -f ./docker-compose.aurum.yaml run nbc
echo Exit code from nbc: $?


# TODO now run the other things from demo


docker-compose -f ./docker-compose.aurum.yaml down

wait $services_pid
echo services exit code $?
