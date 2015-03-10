#!/bin/bash
cd
if [ ! -d ~/Engine ]; then
  git clone https://github.com/fp7-netide/Engine
  echo "export PYTHONPATH=\$PYTHONPATH:~/Engine/ryu-backend:~/Engine/ryu-backend/tests" >> $HOME/.bashrc
  echo "export PYTHONPATH=\$PYTHONPATH:~/Engine/ryu-backend:~/Engine/ryu-backend/tests" >> $HOME/.profile
  
  cp Engine/ryu-backend/netide /usr/local/lib/python2.7/dist-packages/ryu/
  
else
  echo "Engine Repo already exists. Skipping..."
fi