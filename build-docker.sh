#!/bin/bash -ex

rsync -a ~/cqx/c/uchicago/datastation/blindml docker/ --delete
rsync -a ~/cqx/c/uchicago/datastation/aurum-datadiscovery docker/ --delete
rsync -a ~/cqx/c/uchicago/datastation/blindml-dod-integ docker/ --delete --exclude=blindml-dod-integ/venv-*

cd docker
docker build .
