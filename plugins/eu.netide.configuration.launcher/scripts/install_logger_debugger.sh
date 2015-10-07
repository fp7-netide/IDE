#!/bin/bash

if [ ! -d ~/Tools ]; then

	cd
	git clone -b development https://github.com/fp7-netide/Tools
	cd
	mkdir rabbitmq
	cd rabbitmq
	sudo apt-get --yes install rabbitmq-server
	wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.4.4/rabbitmq-server_3.4.4-1_all.deb
	sudo dpkg -i rabbitmq-server_3.4.4-1_all.deb
	
	cp -r $HOME/Tools/logger/Ryu_shim/logpub.py $HOME/Engine/ryu-shim/
	cp -r $HOME/Tools/logger/Ryu_shim/ryu_shim.py $HOME/Engine/ryu-shim/
	
	cp -r $HOME/Tools/logger/POX_shim/logpub.py $HOME/pox/ext
	cp -r $HOME/Tools/logger/POX_shim/pox_client.py $HOME/pox/ext
	
	cd /tmp
	wget http://www.secdev.org/projects/scapy/files/scapy-2.3.1.zip
	unzip scapy-2.3.1.zip
	cd scapy-2.3.1/
	sudo python setup.py install
	
	sudo invoke-rc.d rabbitmq-server start
	
	sudo apt-get install python-pip git-core
	sudo pip install pika==0.9.8
	
else

   echo "Logger seems to be already installed. Skipping..."
fi