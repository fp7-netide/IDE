#!/bin/bash
cd
if [ ! -d ~/Engine ]; then

   sudo apt-get --yes install ant openjdk-7-jdk openjdk-7-doc openjdk-7-jre-lib
   git clone https://github.com/floodlight/floodlight.git -b v0.90

   git clone -b development https://github.com/fp7-netide/Engine
   cp -r Engine/fl-odl/src/main/java/net/floodlightcontroller/interceptor/ floodlight/src/main/java/net/floodlightcontroller/
   cp -r Engine/utils/ide/floodlightdefault.properties floodlight/src/main/resources
   cp -r Engine/utils/ide/net.floodlightcontroller.core.module.IFloodlightModule floodlight/src/main/resources/META-INF/services
   cp -r Engine/utils/ide/build.xml floodlight
   cp -r Engine/utils/ide/json-20140107.jar floodlight/lib
   
   cd floodlight/
   ant
   
elif [ ! -d ~/floodlight ]; then
   
   sudo apt-get --yes install ant openjdk-7-jdk openjdk-7-doc openjdk-7-jre-lib
   git clone https://github.com/floodlight/floodlight.git -b v0.90

   cp -r Engine/fl-odl/src/main/java/net/floodlightcontroller/interceptor/ floodlight/src/main/java/net/floodlightcontroller/
   cp -r Engine/utils/ide/floodlightdefault.properties floodlight/src/main/resources
   cp -r Engine/utils/ide/net.floodlightcontroller.core.module.IFloodlightModule floodlight/src/main/resources/META-INF/services
   cp -r Engine/utils/ide/build.xml floodlight
   cp -r Engine/utils/ide/json-20140107.jar floodlight/lib
   
   cd floodlight/
   ant
   
else

   echo "Floodlight seems to be already installed. Skipping..."
  
fi