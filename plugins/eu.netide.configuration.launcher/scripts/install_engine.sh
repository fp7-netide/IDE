#!/bin/bash

cd

if [ ! -d ~/Engine ]; then
  git clone https://github.com/fp7-netide/Engine
fi

x="export PYTHONPATH=\$PYTHONPATH:~/Engine/libraries/netip/python"

echo "$x" >> $HOME/.bashrc
echo "$x" >> $HOME/.profile

# TODO: install netip libraries so that java can find them
