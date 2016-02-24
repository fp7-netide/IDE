#!/bin/bash
if [ ! -d ~/core_engine ]; then

  sudo apt-get --yes update
  sudo apt-get --yes install maven
  sudo add-apt-repository --yes ppa:webupd8team/java
  sudo apt-get --yes update
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
  sudo apt-get --yes install oracle-java8-installer
  sudo apt-get --yes install oracle-java8-set-default
  
  mkdir core_engine
  cd core_engine
  git clone -b demo-brussels https://github.com/fp7-netide/Engine
  
  cd Engine/libraries/netip/java
  mvn clean install -Dgpg.skip=true
  
  cd
  cd core_engine/Engine/core
  mvn clean install
  cd tools/emulator
  mvn clean install
  cd target
  cp emulator-1.0-jar-with-dependencies.jar /home/vagrant/composition/


  cd
  wget -q http://ftp.fau.de/apache/karaf/3.0.6/apache-karaf-3.0.6.tar.gz
  tar xzf apache-karaf-3.0.6.tar.gz
  cd apache-karaf-3.0.6/bin
  chmod +x ./client ./start ./stop
  echo "Installing karaf dependencies for core"
  ./start
   
  while [ $(./client test 2>&1 | grep "Failed to get the session." | wc -l) -eq 1 ]; do
    echo "No Connection to Karaf server. Trying again..."
	sleep 1
  done
   
  ./client "feature:repo-add mvn:eu.netide.core/core/1.0.0.0-SNAPSHOT/xml/features"
  ./client "feature:install netide-core"
  sleep 10
  ./stop

  cd 

#  mv apache-karaf-3.0.6-SNAPSHOT apache-karaf
# cd apache-karaf-3.0.6-SNAPSHOT/bin
  
  
else
   echo "Engine seems to be already installed. Skipping..."
fi
