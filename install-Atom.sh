#!/bin/bash
#mkdir -p tmp_atom
#cd tmp_atom
#wget https://atom.io/download/deb
#mv deb atom-amd64.deb
#sudo dpkg -i atom-amd64.deb
#cd ..
#rm -rf tmp_atom
wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add
sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ \any main" > /etc/apt/sources.list.d/atom.list'
sudo apt-get update
sudo apt-get install atom
