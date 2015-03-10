#!/bin/bash
if [ "$(which pip)" == "" ] || [ "$(pip list | grep ryu)" == "" ]; then
#  sudo apt-get update
#  sudo apt-get install -y python-dev python-repoze.lru libxml2-dev libxslt-dev libxslt1-dev python-pip zlib1g-dev
#  sudo pip install ryu
#  sudo pip install WebOb
 # sudo pip install routes
 ## sudo pip install paramiko
 # sudo apt-get install python-oslo.config
 # sudo apt-get install python-msgpack
 # sudo apt-get install python-netaddr
 # sudo apt-get install python-lxml
  #sudo apt-get install python-greenlet
  #
  
  sudo apt-get --yes install python-pip python-dev python-repoze.lru libxml2-dev libxslt1-dev zlib1g-dev
  sudo pip install ecdsa
  sudo pip install stevedore
  sudo pip install greenlet
  sudo pip install ryu
  
else
  echo "Ryu already installed. Skipping..."
fi