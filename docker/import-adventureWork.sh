#!/bin/bash -ex

sudo -u elastic -i elasticsearch &

cd /aurum-datadiscovery/ddprofiler

bash ./run.sh --source=/adventureWork.yaml

cd /aurum-datadiscovery

python3 networkbuildercoordinator.py --opath /model --tpath /adventureWork/

killall --wait java
