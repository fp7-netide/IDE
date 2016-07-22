#!/bin/bash

if [ ! -d ~/netide/onos ]; then

  if [ ! -d ~/netide/Engine ]; then
    cd ~/netide
    git clone https://github.com/fp7-netide/Engine.git
  else
   echo "Engine seems to be already installed. Skipping..."
  fi

  cd ~/netide/
  git clone https://gerrit.onosproject.org/onos
  sleep 5
  git clone https://gerrit.onosproject.org/onos
  cd onos
  git checkout onos-1.4
  mvn clean install

  cd ~/netide/Engine/onos-shim
  mvn clean install

sh -c 'echo "# NetIDE cell

# the address of the VM to install the package onto
export OC1=\"192.168.56.101\"

# the default address used by ONOS utilities when none are supplied
export OCI=\"192.168.56.101\"

# the ONOS apps to load at startup
export ONOS_APPS=\"drivers,openflow,proxyarp,mobility\"

# the Mininet VM (if you have one)
#export OCN=\"192.168.56.102\"

# pattern to specify which address to use for inter-ONOS node communication (not used with single-instance core)
export ONOS_NIC=\"192.168.56.*\"

export ONOS_USER=karaf
export ONOS_GROUP=karaf
export ONOS_WEB_USER=karaf
export ONOS_WEB_PASS=karaf" > ~/netide/onos/tools/test/cells/netide'

else
  echo "ONOS already installed. Skipping..."
fi
