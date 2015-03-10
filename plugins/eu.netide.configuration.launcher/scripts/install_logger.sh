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
fi