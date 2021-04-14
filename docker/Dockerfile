FROM debian:stretch
# use stretch instead of buster because this stuff won't build against
# python 3.7 (lots of old pinned packages in requirements.txt)

# FROM debian:buster
RUN apt-get update && apt-get upgrade -y
RUN apt-get update && apt-get install -y sudo curl less net-tools git vim


# Install specific JDK because openjdk 11 vs dod doesn't work
# JDK needs to be manually downloaded through oracle's clickthrough
# system - this dockerfile cannot fetch it automatically

WORKDIR /

ADD jdk-8u281-linux-x64.tar.gz /
# docker will extract this as part of the ADD command

# Install elasticsearch
# quickstart says v6  or above.
RUN curl -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.0.0.tar.gz

RUN tar xzvf elasticsearch*.tar.gz

# the elasticsearch tarball is pretty weird permissions for
# installing as root. this hacks away at the defaults

RUN adduser --system elastic
# other users cannot access certain parts of this tree by default
# so fix that
# RUN find /elasticsearch-7.11.1/ -type f -exec chmod a+r {} \;
# RUN find /elasticsearch-7.11.1/ -type d -exec chmod a+rx {} \;
# Default elasticsearch wants to write into the logs/ subdirectory
# RUN chmod a+rw /elasticsearch-7.11.1/logs/

RUN chown -R elastic /elasticsearch-*/

# quickstart guide set of prereqs
RUN apt-get update && apt-get install -y pkg-config libpng-dev libfreetype6-dev libblas-dev liblapack-dev lib32ncurses5-dev

# my extra discovered pre-reqs
RUN apt-get update && apt-get install -y libpq-dev g++ virtualenv libreadline-dev make

# python3.6 install because neither python 3.5 (from this debian) nor python 3.7 (from next debian) is suitable at the moment.
# instructions from https://gist.github.com/mattseymour/08456b01c467859fba625ba5711fa08e

RUN apt-get update && apt-get install -y build-essential checkinstall
RUN apt-get update && apt-get install -y libbz2-dev libc6-dev libgdbm-dev libncursesw5-dev libreadline-gplv2-dev libssl-dev libsqlite3-dev tk-dev

RUN curl -O https://www.python.org/ftp/python/3.6.13/Python-3.6.13.tgz
RUN tar xzf Python-3.6.13.tgz

WORKDIR /Python-3.6.13

RUN ./configure
RUN make
RUN make install

ADD cue.shell /
RUN chmod a+x /cue.shell


ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# set the environment for elasticsearch to start properly

RUN chsh elastic --shell /bin/bash

RUN echo 'export PATH=/elasticsearch-6.0.0/bin:$PATH' >> /etc/profile.d/datastation.sh
RUN echo 'export JAVA_HOME=/jdk1.8.0_281/' >> /etc/profile.d/datastation.sh
RUN echo 'export PATH=/jdk1.8.0_281/bin:$PATH' >> /etc/profile.d/datastation.sh

# The python build:

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


# The java build:
# elasticsearch installed by cue/benc/datastation-dod
# but the path to it needs setting
ENV PATH=/elasticsearch-6.0.0/bin:$PATH

ENV JAVA_HOME=/jdk1.8.0_281/
ENV PATH=/jdk1.8.0_281/bin:$PATH

WORKDIR /aurum-datadiscovery/ddprofiler
RUN bash build.sh


# The sample dataset:

WORKDIR /
ADD adventureWork.zip /adventureWork.zip
RUN apt-get update && apt-get install -y unzip
RUN unzip adventureWork.zip
RUN rm adventureWork.zip

# Import dataset into elasticsearch

## needed for killall used by import-adventureWork
RUN apt-get update && apt-get install -y psmisc
ADD import-adventureWork.sh /import-adventureWork.sh 
ADD adventureWork.yaml /adventureWork.yaml
RUN /import-adventureWork.sh 

# jupyter notebook config

RUN mkdir /root/.jupyter
# this config contains a hashed default password
ADD jupyter_notebook_config.json /root/.jupyter/jupyter_notebook_config.json

RUN mkdir /notebooks
ADD notebooks/* /notebooks/

# this is because blindml packaging can't deal with these files
# that live in the source tree.
ADD blindml/*.json /notebooks/

# because dod does not make its own result directory. it probably should be made to...
RUN mkdir /notebooks/testres

ADD cmd.sh /cmd.sh
CMD /cmd.sh

EXPOSE 8888
