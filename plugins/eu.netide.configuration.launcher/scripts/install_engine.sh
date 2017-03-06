#!/bin/bash
cd

if [ ! -d ~/netide/Engine ]; then
  cd netide
  git clone https://github.com/fp7-netide/Engine
  cd
fi

x="export PYTHONPATH=\$PYTHONPATH:~/netide/Engine/libraries/netip/python"

echo "$x" >> $HOME/.bashrc
echo "$x" >> $HOME/.profile

# TODO: install netip libraries so that java can find them
