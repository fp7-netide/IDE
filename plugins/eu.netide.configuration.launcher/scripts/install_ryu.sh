#!/bin/bash
if [ $(pip list | grep ryu) == "" ]; then
  sudo apt-get update
  sudo apt-get install -y python-pip
  sudo pip install ryu
else
  echo "Ryu already installed. Skipping..."
fi