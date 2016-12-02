#!/bin/bash
cd
if [ ! -d ~/netide/mininet ]; then
  #sudo apt-get update -y
  #sudo apt-get install git -y
  #git clone git://github.com/mininet/mininet
  #mininet/util/install.sh -a
  
  
  #sudo apt-get update -y
  #sudo apt-get install mininet -y
  #sudo service openvswitch-controller stop
  #sudo update-rc.d openvswitch-controller disable
  #sudo apt-get install openvswitch-datapath-dkms
  #sudo dpkg-reconfigure openvswitch-datapath-dkms
  #sudo service openflow-switch restart
  
  cd netide
  git clone https://github.com/mininet/mininet
  mininet/util/install.sh -a
  
  if [ ! -d ~/netide/controllers ]; then
    mkdir ~/netide/controllers
  fi
else
  echo "Mininet seems to be installed already. Skipping..."
fi