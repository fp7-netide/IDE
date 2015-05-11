#!/bin/bash
cd
if [ ! -d ~/mininet ]; then
  #sudo apt-get update -y
  #sudo apt-get install git -y
  #git clone git://github.com/mininet/mininet
  #mininet/util/install.sh -a
  
  
  sudo apt-get update -y
  sudo apt-get install git -y
  sudo apt-get install mininet -y
  sudo service openvswitch-controller stop
  sudo update-rc.d openvswitch-controller disable
  
  sudo dpkg-reconfigure openvswitch-datapath-dkms
  sudo service openflow-switch restart
  
  git clone git://github.com/mininet/mininet
  mininet/util/install.sh -fw
  
  if [ ! -d ~/controllers ]; then
    mkdir ~/controllers
  fi
else
  echo "Mininet seems to be installed already. Skipping..."
fi