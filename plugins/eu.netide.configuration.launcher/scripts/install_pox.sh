#!/bin/bash
if [ ! -d ~/netide/pox ]; then

  sudo apt-get --yes install python-pip python-dev python-repoze.lru libxml2-dev libxslt1-dev zlib1g-dev
  sudo -E pip install ecdsa
  sudo -E pip install stevedore
  sudo -E pip install greenlet

  cd netide
  git clone http://github.com/noxrepo/pox

  echo "export PYTHONPATH=\$PYTHONPATH:$HOME/pox" >> $HOME/.bashrc

  cp -r Engine/ryu-backend/tests/pox_client.py pox/ext

else
  echo "Pox already installed. Skipping..."
fi
