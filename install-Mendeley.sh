sudo apt install gconf2
sudo apt install python
mkdir -p tmp_mendeley
cd tmp_google
wget https://www.mendeley.com/repositories/ubuntu/stable/amd64/mendeleydesktop-latest
sudo dpkg -i mendeleydesktop-latest
cd ..
rm -rf tmp_mendeley
