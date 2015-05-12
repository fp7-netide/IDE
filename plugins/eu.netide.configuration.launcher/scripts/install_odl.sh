#!/bin/bash
cd
if [ ! -d ~/Engine ]; then

   sudo apt-get --yes install maven openjdk-7-jdk openjdk-7-doc openjdk-7-jre-lib
   git clone https://git.opendaylight.org/gerrit/openflowplugin
   cd openflowplugin
   git checkout release/helium-sr1.1
   mvn clean install -DskipTests
   cd ..
   
   git clone -b development https://github.com/fp7-netide/Engine
   cd Engine/odl-shim
   cp pom.xml pom_other_release.xml
   cp pom_sr1.xml pom.xml
   mvn clean install
   
elif [ ! -d ~/openflowplugin ]; then
   
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
   
else

   echo "ODL seems to be already installed. Skipping..."
  
fi