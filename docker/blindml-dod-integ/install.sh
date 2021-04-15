#!/bin/bash -e
export LANG=C.UTF-8
export V=venv-$(date +%s)
virtualenv $V --python=python3
source ${V}/bin/activate
pip install -r ./requirements.txt

# the blindml tests in my fork need to run from the blindml
# directory, for a few reasons: pytest rooted there; various
# .json files are loaded and the packaging doesn't install
# them properly where they can be found in a location
# independent way.
pushd ../blindml
./quick-test.sh
popd
