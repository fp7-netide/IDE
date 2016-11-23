#!/bin/bash
cd
if [ ! -d ~/netide/openflowplugin ]; then


   cd netide
   echo "Downloading OpenDaylight Karaf Distribution"
   wget -q https://nexus.opendaylight.org/content/repositories/opendaylight.release/org/opendaylight/integration/distribution-karaf/0.5.1-Boron-SR1/distribution-karaf-0.5.1-Boron-SR1.tar.gz

   tar -xzf distribution-karaf-0.5.1-Boron-SR1.tar.gz
   rm distribution-karaf-0.5.1-Boron-SR1.tar.gz
   
   mv distribution-karaf-0.5.1-Boron-SR1 odl-karaf

   cd odl-karaf

   cd bin

   chmod +x ./client ./start ./stop
   echo "Installing karaf dependencies for ODL shim"
   ./start

   while [ $(./client test 2>&1 | grep "Failed to get the session." | wc -l) -eq 1 ]; do
	echo "No Connection to Karaf server. Trying again..."
	sleep 1
   done


   ./client "feature:install odl-netide-rest"
   ./client "feature:install odl-restconf-all"
   sleep 10
   ./stop

   cd ..

   sed -i 's/44444/44445/g' etc/org.apache.karaf.management.cfg
   sed -i 's/1099/1098/g' etc/org.apache.karaf.management.cfg

   cd

else

   echo "ODL seems to be already installed. Skipping..."

fi
