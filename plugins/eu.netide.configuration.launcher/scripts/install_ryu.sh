#!/bin/bash
if [ "$(which pip)" == "" ] || [ "$(pip list | grep ryu)" == "" ]; then

  sudo apt-get --yes install python-pip python-dev python-repoze.lru libxml2-dev libxslt1-dev zlib1g-dev
  sudo pip install ecdsa
  sudo pip install stevedore
  sudo pip install greenlet
  sudo pip install ryu
  #git clone git://github.com/osrg/ryu.git
  #cd ryu
  #sudo python ./setup.py install
  
  #echo "export PYTHONPATH=\$PYTHONPATH:$HOME/ryu:/usr/local/lib/python2.7/dist-packages/ryu" >> $HOME/.bashrc
    
else
  echo "Ryu already installed. Skipping..."
fi