#!/bin/bash -ex

sudo -u elastic -i elasticsearch &

cd /aurum-datadiscovery/ddprofiler

bash ./run.sh --source=/adventureWork.yaml

killall --wait java
