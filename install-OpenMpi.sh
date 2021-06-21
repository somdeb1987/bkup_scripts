mkdir -p tmp_openmpi
cd tmp_OPENMPI
wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.0.tar.bz2
tar -jxf openmpi-4.1.0.tar.bz2
cd openmpi-4.1.0
./configure --prefix=$HOME/.openmpi
make all
make install
cd ..
cd ..
rm -rf tmp_OPENMPI
echo "export PATH=\$PATH:\$HOME/.openmpi/bin" >> $HOME/.bashrc
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$HOME/.openmpi/lib" >> $HOME/.bashrc
