#!/bin/bash
if [ ! -d ~/core_engine ]; then

  sudo apt-get --yes update
  sudo apt-get --yes install maven
  sudo add-apt-repository --yes ppa:webupd8team/java
  sudo apt-get --yes update
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
  sudo apt-get --yes install oracle-java8-installer
  sudo apt-get --yes install oracle-java8-set-default

  cd
  cd netide
  git clone -b https://github.com/fp7-netide/Engine

  cd Engine/libraries/netip/java
  mvn clean install -Dgpg.skip=true

  cd
  cd netide/Engine/core
  mvn clean install
  cd tools/emulator
  mvn clean install -Dgpg.skip=true
  cd target
  cp emulator-1.0-jar-with-dependencies.jar ~/netide/composition/


  cd
  echo "Downloading Karaf..."
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

  ./client "feature:repo-add mvn:eu.netide.core/core/1.1.0-SNAPSHOT/xml/features"
  ./client "feature:install core"
  sleep 15
  ./stop

#  mv apache-karaf-3.0.6-SNAPSHOT apache-karaf
# cd apache-karaf-3.0.6-SNAPSHOT/bin
else
  echo "Engine seems to be already installed. Skipping..."
fi
