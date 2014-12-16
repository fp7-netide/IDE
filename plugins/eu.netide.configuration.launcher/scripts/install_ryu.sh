#!/bin/bash
if [ "$(which pip)" == "" ] || [ "$(pip list | grep ryu)" == "" ]; then
  sudo apt-get update
  sudo apt-get install -y python-dev libxml2-dev libxslt-dev python-pip
  sudo pip install ryu
  sudo pip install WebOb
  sudo pip install routes
  sudo pip install paramiko
  sudo apt-get install python-oslo.config
  sudo apt-get install python-msgpack
  sudo apt-get install python-netaddr
  sudo apt-get install python-lxml
  sudo apt-get install python-greenlet
else
  echo "Ryu already installed. Skipping..."
fi