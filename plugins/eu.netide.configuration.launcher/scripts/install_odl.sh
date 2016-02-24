#!/bin/bash
cd
if [ ! -d ~/openflowplugin ]; then
    sudo add-apt-repository ppa:andrei-pozolotin/maven3
   sudo apt-get update
   sudo apt-get --yes install maven3 openjdk-7-jdk openjdk-7-doc openjdk-7-jre-lib
   mkdir -p ~/.m2
   wget -q -O - https://raw.githubusercontent.com/opendaylight/odlparent/master/settings.xml > ~/.m2/settings.xml

   cd Engine/odl-shim
   mvn clean install

   cd karaf/target/assembly/bin

   chmod +x ./client ./start ./stop
   echo "Installing karaf dependencies for ODL shim"
   ./start
   
   while [ $(./client test 2>&1 | grep "Failed to get the session." | wc -l) -eq 1 ]; do
	echo "No Connection to Karaf server. Trying again..."
	sleep 1
   done
   

   ./client "feature:install odl-netide-rest"
   ./client "feature:install odl-restconf"
   sleep 10
   ./stop

   cd 
   
else

   echo "ODL seems to be already installed. Skipping..."
  
fi
