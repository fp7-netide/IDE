#!/bin/bash

if [ ! -d netide/floodlight ]; then

 sudo apt-get install --yes ant

 cd netide/
 git clone https://github.com/floodlight/floodlight.git
 cd floodlight
 git checkout v1.1

 make

 cp -r ~/netide/Engine/floodlight-backend/v1.2/src/main/java/net/floodlightcontroller/interceptor src/main/java/net/floodlightcontroller/
 cp ~/netide/Engine/floodlight-backend/v1.2/lib/{jeromq-0.3.4.jar,javatuples-1.2.jar,netip-1.1.0-SNAPSHOT.jar} lib/
 cp ~/netide/Engine/floodlight-backend/v1.2/src/main/resources/floodlightdefault.properties src/main/resources/floodlightdefault.properties

 sed -i '/<patternset id="lib">/a <include name="netip-1.1.0-SNAPSHOT.jar"/>' build.xml
 sed -i '/<patternset id="lib">/a <include name="javatuples-1.2.jar"/>' build.xml
 sed -i '/<patternset id="lib">/a <include name="jeromq-0.3.4.jar"/>' build.xml
 sed -i '$ a net.floodlightcontroller.interceptor.NetIdeModule' src/main/resources/META-INF/services/net.floodlightcontroller.core.module.IFloodlightModule
 sed -i 's/6653/7753/' src/main/java/net/floodlightcontroller/core/internal/Controller.java


 sed -i 's/JVM_OPTS="\$JVM_OPTS -XX:CompileThreshold=1500 -XX:PreBlockSpin=8"/JVM_OPTS="\$JVM_OPTS -XX:CompileThreshold=1500"/' floodlight.sh
 sed -i '/FL_HOME=.*/i cd \$(dirname \$0)' floodlight.sh
 sed -i 's/FL_HOME=.*/FL_HOME=\./' floodlight.sh


 make
fi
