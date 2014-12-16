#!/bin/bash
cd
if [ ! -d ~/mininet ]; then
  sudo apt-get update -y
  sudo apt-get install git -y
  git clone git://github.com/mininet/mininet
  mininet/util/install.sh -a
  if [ ! -d ~/controllers ]; then
    mkdir ~/controllers
  fi
else
  echo "Mininet seems to be installed already. Skipping..."
fi