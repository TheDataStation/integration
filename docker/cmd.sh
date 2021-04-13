#!/bin/bash -ex

echo cmd.sh: starting

sudo -u elastic -i elasticsearch &

jupyter notebook --allow-root --ip 0.0.0.0

echo cmd.sh: done
