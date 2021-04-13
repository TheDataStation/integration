# start with benc's development environment
# which was originally intended to use home-dir
# mounted stuff.
FROM cue/benc/datastation-dod 

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN pip3 install --upgrade pip

ADD blindml /blindml
ADD aurum-datadiscovery /aurum-datadiscovery
ADD blindml-dod-integ /aurum-dod-integ

RUN find /blindml /aurum-datadiscovery /aurum-dod-integ -depth -name __pycache__ -exec rm -rfv {} \;
RUN find /blindml /aurum-datadiscovery /aurum-dod-integ -depth -name \*.pyc -exec rm -rfv {} \;

# RUN apt-get update && apt-get install -y swig

WORKDIR /
RUN pip3 install -e blindml/ aurum-datadiscovery/ 

# validate these installs:
WORKDIR /blindml
RUN ./quick-test.sh

