#!/bin/bash

cd
mkdir -p netide
sudo chown -R 1000:1000 netide
sudo apt-get update
sudo apt-get install --yes git screen python python3 python-pip python3-pip python-dev python3-dev

sudo add-apt-repository ppa:andrei-pozolotin/maven3
sudo apt-get update
sudo apt-get --yes install maven3 openjdk-7-jdk openjdk-7-doc openjdk-7-jre-lib

mkdir -p ~/.m2
wget -q -O - https://raw.githubusercontent.com/opendaylight/odlparent/master/settings.xml > ~/.m2/settings.xml
