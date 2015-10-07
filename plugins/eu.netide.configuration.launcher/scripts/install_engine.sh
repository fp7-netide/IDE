#!/bin/bash
cd

if [ ! -d ~/Engine ]; then
  git clone https://github.com/fp7-netide/Engine
fi

# TODO: install netip libraries so that java and python can find them

#echo "export PYTHONPATH=\$PYTHONPATH:~/Engine/ryu-backend:~/Engine/ryu-backend/tests" >> $HOME/.bashrc
#echo "export PYTHONPATH=\$PYTHONPATH:~/Engine/ryu-backend:~/Engine/ryu-backend/tests" >> $HOME/.profile

#echo "export PYTHONPATH=\$PYTHONPATH:~/Engine/ryu-shim" >> $HOME/.bashrc
#echo "export PYTHONPATH=\$PYTHONPATH:~/Engine/ryu-shim" >> $HOME/.profile
