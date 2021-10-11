FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y
RUN apt-get update && apt-get install -y sudo curl less net-tools git vim

RUN apt-get install -y openjdk-11-jdk

WORKDIR /

# quickstart guide set of prereqs
RUN apt-get update && apt-get install -y pkg-config libpng-dev libfreetype6-dev libblas-dev liblapack-dev lib32ncurses5-dev

# my extra discovered pre-reqs
RUN apt-get update && apt-get install -y libpq-dev g++ virtualenv libreadline-dev make

RUN apt-get update && apt-get install -y python3

ADD cue.shell /
RUN chmod a+x /cue.shell


ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# The python build:

RUN pip3 install --upgrade pip

RUN git clone https://github.com/TheDataStation/blindml /blindml --branch benc-dod-integration && cd /blindml && git checkout 9ab29e04b8750de993a6e57e5dd10b9a779bb60c

RUN git clone https://github.com/TheDataStation/aurum-dod-staging /aurum-datadiscovery --branch benc-blindml-integration && cd /aurum-datadiscovery && git checkout 99012ce38449e39c9d08300470fb149b77d4ff9d

ADD blindml-dod-integ /blindml-dod-integ

WORKDIR /
RUN pip3 install -r blindml-dod-integ/requirements.txt

# (blindml doesn't have enough in it to validate itself when
# installed from pip, not from source tree)
# would be nice to have this validation though

# validate these installs:
# WORKDIR /blindml
#RUN ./quick-test.sh


ADD blindml-dod-integ /blindml-dod-integ

RUN git clone https://github.com/TheDataStation/ddprofiler /ddprofiler --branch main && cd /ddprofiler && git checkout 067e6e3d5b88e39d739a5c646cb9de6be1ed37b0

WORKDIR /ddprofiler
RUN bash build.sh


# The sample dataset:

WORKDIR /
ADD adventureWork.zip /adventureWork.zip
RUN apt-get update && apt-get install -y unzip
RUN unzip adventureWork.zip
RUN rm adventureWork.zip

# and the other sample dataset
RUN mkdir /datasets/
WORKDIR /datasets/
RUN git clone https://github.com/scpike/us-state-county-zip/
# RUN cp /datasets/us-state-county-zip/*.csv /adventureWork/

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
RUN cp /blindml/*.json /notebooks/

# because dod does not make its own result directory. it probably should be made to...
RUN mkdir /notebooks/testres

# integration API, could be installed/packaged with pip, or done entirely differently
RUN cp /blindml-dod-integ/blindml_dod_integ.py /notebooks/

# for view presentation:
RUN mkdir /adhoc-python
ADD view_presentation_dod /adhoc-python/view_presentation_dod

ADD cmd.sh /cmd.sh
CMD /cmd.sh

EXPOSE 8888
