#!/bin/bash
if [ "$(which pip)" == "" ] || [ "$(pip list | grep ryu)" == "" ]; then

  sudo apt-get --yes install python-pip python-dev python-repoze.lru libxml2-dev libxslt1-dev zlib1g-dev python-zmq python3-zmq
  sudo -E pip install ecdsa
  sudo -E pip install stevedore
  sudo -E pip install greenlet
  sudo -E pip install ryu
  

  sudo cp -r Engine/ryu-backend/netide /usr/local/lib/python2.7/dist-packages/ryu/
  sudo cp -r Engine/ryu-shim/netide /usr/local/lib/python2.7/dist-packages/ryu/

  mkdir -p ryu/ryu
  cp -r Engine/ryu-backend/netide ryu/ryu
  cp -r Engine/ryu-shim/netide ryu/ryu

  #git clone git://github.com/osrg/ryu.git
  #cd ryu
  #sudo python ./setup.py install
  
  #echo "export PYTHONPATH=\$PYTHONPATH:$HOME/ryu:/usr/local/lib/python2.7/dist-packages/ryu" >> $HOME/.bashrc
    
else
  echo "Ryu already installed. Skipping..."
fi
