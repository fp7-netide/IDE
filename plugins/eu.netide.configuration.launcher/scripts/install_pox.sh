#!/bin/bash
if [ ! -d ~/pox ]; then

  sudo apt-get --yes install python-pip python-dev python-repoze.lru libxml2-dev libxslt1-dev zlib1g-dev
  sudo pip install ecdsa
  sudo pip install stevedore
  sudo pip install greenlet

  git clone http://github.com/noxrepo/pox

echo "export PYTHONPATH=\$PYTHONPATH:$HOME/pox" >> $HOME/.bashrc
    
else
  echo "Pox already installed. Skipping..."
fi