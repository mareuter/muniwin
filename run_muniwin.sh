#!/bin/bash

# Script for running muniwin container on MacOS

ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
xhost + $ip

docker run --name "muniwin" -it -e DISPLAY=$ip:0 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ${HOME}/Pictures/AstroImaging:/home/muniuser/data \
    mareuter/muniwin:latest