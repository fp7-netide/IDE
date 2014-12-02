#!/bin/bash
cd
if [ ! -d ~/mininet ]; then
  sudo apt-get update -y
  sudo apt-get install git -y
  git clone git://github.com/mininet/mininet
  mininet/util/install.sh -a
else
  echo "Mininet seems to be installed already. Skipping..."
fi