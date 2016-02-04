#!/bin/bash
if [ "$(which pip)" == "" ] || [ "$(pip list | grep ryu)" == "" ]; then

  if [ ! -d ~/Engine ]; then
  git clone https://github.com/fp7-netide/Engine
  
  else
   echo "Engine seems to be already installed. Skipping..."
  fi
  
  sudo apt-get --yes install python-pip python-dev python-repoze.lru libxml2-dev libxslt1-dev zlib1g-dev python-zmq
  sudo -E pip install ecdsa
  sudo -E pip install stevedore
  sudo -E pip install greenlet
  sudo -E pip install ryu
  
  mkdir -p ryu/ryu
  cp -r Engine/libraries/netip/python ryu/ryu
  mv ryu/ryu/python ryu/ryu/netide
  
  cp -r Engine/libraries/netip/python/netip.py Engine/ryu-backend
  cp -r Engine/libraries/netip/python/netip.py Engine/ryu-shim
  
  sudo cp -r ryu/ryu/netide /usr/local/lib/python2.7/dist-packages/ryu/
  sudo cp -r ryu/ryu/netide /usr/local/lib/python2.7/dist-packages/ryu/
 
  echo "export PYTHONPATH=\$PYTHONPATH:$HOME/ryu:/usr/local/lib/python2.7/dist-packages/ryu" >> $HOME/.bashrc
    
else
  echo "Ryu already installed. Skipping..."
fi