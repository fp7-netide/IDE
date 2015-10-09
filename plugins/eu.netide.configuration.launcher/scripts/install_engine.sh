#!/bin/bash
cd

if [ ! -d ~/Engine ]; then
  git clone -b pyretic_intermediate_protocol https://github.com/fp7-netide/Engine
  
else
   echo "Engine seems to be already installed. Skipping..."
fi