#!/bin/bash
if [ ! -d ~/.m2/repository/eu/netide/core/ ]; then

  sudo apt-get --yes update
  sudo apt-get --yes install maven
  sudo add-apt-repository --yes ppa:webupd8team/java
  sudo apt-get --yes update
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
  sudo apt-get --yes install oracle-java8-installer
  sudo apt-get --yes install oracle-java8-set-default

  cd
  mkdir -p netide
  cd ~/netide
  git clone https://github.com/fp7-netide/Engine

  cd
  cd ~/netide/Engine/core
  mvn clean install -Dgpg.skip=true

  cd
  echo "Downloading Karaf..."
  wget -q http://www-eu.apache.org/dist/karaf/3.0.8/apache-karaf-3.0.8.tar.gz
  tar xzf apache-karaf-3.0.8.tar.gz
  mv apache-karaf-3.0.8 netide/core-karaf
  cd netide/core-karaf/bin
  chmod +x ./client ./start ./stop
  echo "Installing karaf dependencies for core"
  ./start

  while [ $(./client test 2>&1 | grep "Failed to get the session." | wc -l) -eq 1 ]; do
    echo "No Connection to Karaf server. Trying again..."
        sleep 1
  done

  ./client "feature:repo-add mvn:eu.netide.core/core.features/1.1.0-SNAPSHOT/xml/features"
  ./client "feature:install core"
  sleep 15
  ./stop

else
  echo "Engine seems to be already installed. Skipping..."
fi
