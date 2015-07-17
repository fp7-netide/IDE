#!/bin/bash
cd
mkdir -p ryu/ryu pyretic pox/ext

if [ ! -d ~/Engine ]; then
  git clone -b development https://github.com/fp7-netide/Engine
fi

echo "export PYTHONPATH=\$PYTHONPATH:~/Engine/ryu-backend:~/Engine/ryu-backend/tests" >> $HOME/.bashrc
echo "export PYTHONPATH=\$PYTHONPATH:~/Engine/ryu-backend:~/Engine/ryu-backend/tests" >> $HOME/.profile

echo "export PYTHONPATH=\$PYTHONPATH:~/Engine/ryu-shim" >> $HOME/.bashrc
echo "export PYTHONPATH=\$PYTHONPATH:~/Engine/ryu-shim" >> $HOME/.profile

echo "export PYTHONPATH=\$PYTHONPATH:~/pyretic" >> $HOME/.bashrc
echo "export PYTHONPATH=\$PYTHONPATH:~/pyretic" >> $HOME/.profile

sudo cp -r Engine/ryu-backend/netide /usr/local/lib/python2.7/dist-packages/ryu/
sudo cp -r Engine/ryu-shim/netide /usr/local/lib/python2.7/dist-packages/ryu/

cp -r Engine/ryu-backend/netide ryu/ryu
cp -r Engine/ryu-shim/netide ryu/ryu
cp -r Engine/ryu-shim/tests/pyretic.py pyretic/
cp -r Engine/ryu-backend/tests/pox_client.py pox/ext
