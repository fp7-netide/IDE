#!/bin/bash
cd
if [ ! -d ~/Engine ]; then
  git clone https://github.com/fp7-netide/PoC
else
  "The engine Repository already exists. Skipping..."
fi
