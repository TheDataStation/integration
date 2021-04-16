How to build this
=================

1. separately download jdk-8u281-linux-x64.tar.gz
   and place it in:
   docker/jdk-8u281-linux-x64.tar.gz

2. run:

   cd docker

   docker build .

   The last line will tell you the image ID for the image just built.
 
3. run a container with:

   docker run --rm -p 8888:8888 $IMAGEID

   This will start the demo environment with jupyter and elasticsearch.

   Alternatively, if you want a shell, run:

   docker run --rm -p 8888:8888 $IMAGEID /bin/bash

   and inside there you can run /cmd.sh to start the demo environment.
