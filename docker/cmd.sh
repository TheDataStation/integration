#!/bin/bash -ex

echo cmd.sh: starting

sudo -u elastic -i elasticsearch &

echo cmd.sh: sleeping 3 minutes
sleep 3m
echo cmd.sh: done
