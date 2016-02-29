#!/bin/bash

cd
mkdir -p netide
sudo chown -R vagrant:vagrant netide
sudo apt-get update
sudo apt-get install --yes git screen python python3 python-pip python3-pip python-dev python3-dev
