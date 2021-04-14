# start with benc's development environment
# which was originally intended to use home-dir
# mounted stuff.
FROM cue/benc/datastation-dod 

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
