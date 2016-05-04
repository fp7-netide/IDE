#!/bin/bash
if [ "$(which pip)" == "" ] || [ "$(pip list | grep ryu)" == "" ]; then

  if [ ! -d ~/netide/Engine ]; then
    cd ~/netide
    git clone https://github.com/fp7-netide/Engine

  else
   echo "Engine seems to be already installed. Skipping..."
  fi

  sudo apt-get --yes install python-pip python-dev libxml2-dev libxslt1-dev zlib1g-dev python-zmq python3-zmq
  sudo -E pip install ryu
  sudo -E pip install oslo.config
  sudo -E pip install --upgrade ryu

  cd ~/netide/

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
