#!/bin/bash
cd
if [ ! -d ~/openflowplugin ]; then
   
   sudo apt-get --yes install maven openjdk-7-jdk openjdk-7-doc openjdk-7-jre-lib
   git clone https://git.opendaylight.org/gerrit/openflowplugin
   cd openflowplugin
   git checkout release/helium-sr1.1
   mvn clean install -DskipTests
   cd ..
   cd Engine/odl-shim
   mv pom.xml pom_other_release.xml
   mv pom_sr1.xml pom.xml
   mvn clean install

   cd
   cd ./openflowplugin/distribution/karaf/
   mvn clean package
   cd ./target/assembly/bin

   chmod +x ./client ./start ./stop
   echo "Installing karaf dependencies for ODL shim"
   ./start
   sleep 10
   ./client "bundle:install -s mvn:com.googlecode.json-simple/json-simple/1.1.1"
   ./client "bundle:install -s mvn:org.apache.commons/commons-lang3/3.3.2"
   ./client "bundle:install -s mvn:org.opendaylight.openflowplugin/pyretic-odl/0.0.4-Helium-SR1.1"
   sleep 10
   ./stop

   cd 
   
else

   echo "ODL seems to be already installed. Skipping..."
  
fi
