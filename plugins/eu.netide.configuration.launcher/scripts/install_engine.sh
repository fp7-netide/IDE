#!/bin/bash
cd
if [ ! -d ~/Engine ]; then
  git clone -b development https://github.com/fp7-netide/Engine
  echo "export PYTHONPATH=\$PYTHONPATH:~/Engine/ryu-backend:~/Engine/ryu-backend/tests" >> $HOME/.bashrc
  echo "export PYTHONPATH=\$PYTHONPATH:~/Engine/ryu-backend:~/Engine/ryu-backend/tests" >> $HOME/.profile
  
  echo "export PYTHONPATH=\$PYTHONPATH:~/Engine/ryu-shim" >> $HOME/.bashrc
  echo "export PYTHONPATH=\$PYTHONPATH:~/Engine/ryu-shim" >> $HOME/.profile
  
  sudo cp -r Engine/ryu-backend/netide /usr/local/lib/python2.7/dist-packages/ryu/
  sudo cp -r Engine/ryu-shim/netide /usr/local/lib/python2.7/dist-packages/ryu/
else
  echo "Engine Repo already exists. Skipping..."
fi