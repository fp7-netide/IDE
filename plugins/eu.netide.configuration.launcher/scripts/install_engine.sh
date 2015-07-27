#!/bin/bash
cd

if [ ! -d ~/Engine ]; then
  git clone -b development https://github.com/fp7-netide/Engine
fi

#echo "export PYTHONPATH=\$PYTHONPATH:~/Engine/ryu-backend:~/Engine/ryu-backend/tests" >> $HOME/.bashrc
#echo "export PYTHONPATH=\$PYTHONPATH:~/Engine/ryu-backend:~/Engine/ryu-backend/tests" >> $HOME/.profile

#echo "export PYTHONPATH=\$PYTHONPATH:~/Engine/ryu-shim" >> $HOME/.bashrc
#echo "export PYTHONPATH=\$PYTHONPATH:~/Engine/ryu-shim" >> $HOME/.profile
