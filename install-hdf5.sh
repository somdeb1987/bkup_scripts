HDF5_VERSION=1.12
HDF5_FILE_NAME=1.12.0
HDF5_INSTALL_DIRECTORY=$HOME/libraries/hdf5_v`echo $HDF5_VERSION | sed 's/\./p/g'`
FILE_TO_DOWNLOAD=hdf5-$HDF5_VERSION/hdf5-$HDF5_FILE_NAME/src/hdf5-$HDF5_FILE_NAME.tar.gz
DOWNLOAD_FILE_LOCATION=$HOME/libraries/src_tmp/hdf5-$HDF5_FILE_NAME.tar.gz
echo "hdf5 version = "$HDF5_VERSION
echo "hdf5 file name = "$HDF5_FILE_NAME
echo "hdf5 install directory = "$HDF5_INSTALL_DIRECTORY
echo "file to download = "$FILE_TO_DOWNLOAD
echo "source file location= "$DOWNLOAD_FILE_LOCATION
read -p "proceed with this setup (y/n)?" FLAG_PROCEED
if [ "$FLAG_PROCEED" = "y" ]; then
  echo "Let's proceed";
else
  echo "HDF5 installation cancelled";
fi
mkdir -p $HOME/libraries
mkdir -p $HOME/libraries/src_tmp
mkdir -p $HDF5_INSTALL_DIRECTORY
cd $HOME/libraries/src_tmp
if [ -e $DOWNLOAD_FILE_LOCATION ]; then
    echo "File exists"
else 
    echo "File does not exist, downloading now..."
    wget https://support.hdfgroup.org/ftp/HDF5/releases/$FILE_TO_DOWNLOAD
fi
if [ -d "hdf5-"$HDF5_FILE_NAME ] 
then
    echo "Directory "$HOME"/libraries/hdf5-"$HDF5_FILE_NAME" exists. Please check\
     if this version of HDF5 is already installed" 
else
    echo "Directory "$HOME"/libraries/hdf5-"$HDF5_FILE_NAME" does not exists. Installing now"
    tar -xvf hdf5-$HDF5_FILE_NAME.tar.gz
fi
cd hdf5-$HDF5_FILE_NAME
CC=mpicc FC=mpif90 \
  CFLAGS=-fPIC ./configure \
  --enable-shared --enable-parallel \
  --enable-fortran --enable-fortran2003 \
  --prefix=$HDF5_INSTALL_DIRECTORY
make
make install
