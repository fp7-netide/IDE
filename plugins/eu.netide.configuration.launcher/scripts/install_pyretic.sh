#!/bin/bash

if [ ! -d ~/pyretic ]; then
  sudo apt-get install python-dev python-pip python-netaddr screen hping3 ml-lpt graphviz ruby1.9.1-dev libboost-dev libboost-test-dev libboost-program-options-dev libevent-dev automake libtool flex bison pkg-config g++ libssl-dev python-all python-all-dev python-all-dbg

  sudo pip install networkx bitarray netaddr ipaddr pytest ipdb sphinx pyparsing==1.5.7 yappi

  sudo gem install jekyll

  wget https://raw.github.com/frenetic-lang/pyretic/master/pyretic/backend/patch/asynchat.py
  sudo mv asynchat.py /usr/lib/python2.7/
  sudo chown root:root /usr/lib/python2.7/asynchat.py
  git clone https://github.com/git/git.git
  pushd git/contrib/subtree/
  make
  mv git-subtree.sh git-subtree
  sudo install -m 755 git-subtree /usr/lib/git-core
  popd
  rm -rf git

  cd ~
  git clone git://github.com/frenetic-lang/pyretic.git

  echo -e 'export PATH=$PATH:$HOME/pyretic:$HOME/pox\nexport PYTHONPATH=$HOME/pyretic:$HOME/mininet:$HOME/pox' >> .profile

  wget http://frenetic-lang.org/pyretic/useful/.screenrc
else
  echo "Pyretic seems to be already installed. Skipping..."
fi
