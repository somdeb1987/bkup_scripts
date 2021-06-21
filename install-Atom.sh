#!/bin/bash
mkdir -p tmp_atom
cd tmp_atom
wget https://atom.io/download/deb
mv deb atom-amd64.deb
sudo dpkg -i atom-amd64.deb
cd ..
rm -rf tmp_atom 
