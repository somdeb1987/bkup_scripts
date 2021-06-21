ZLIB_VERSION=1.2.11
#wget -c https://www.zlib.net/zlib-1.2.11.tar.gz
ZLIB_INSTALL_DIRECTORY=$HOME/libraries/zlib_v`echo $ZLIB_VERSION | sed 's/\./p/g'`
FILE_TO_DOWNLOAD=zlib-$ZLIB_VERSION.tar.gz
DOWNLOAD_FILE_LOCATION=$HOME/libraries/src_tmp/zlib-$ZLIB_VERSION.tar.gz
echo "zlib version = "$ZLIB_VERSION
echo "zlib install directory = "$ZLIB_INSTALL_DIRECTORY
echo "file to download = "$FILE_TO_DOWNLOAD
echo "source file location= "$DOWNLOAD_FILE_LOCATION
read -p "proceed with this setup (y/n)?" FLAG_PROCEED
if [ "$FLAG_PROCEED" = "y" ]; then
  echo "Let's proceed";
else
  echo "ZLIB installation cancelled";
fi
mkdir -p $HOME/libraries
mkdir -p $HOME/libraries/src_tmp
mkdir -p $ZLIB_INSTALL_DIRECTORY
cd $HOME/libraries/src_tmp
if [ -e $DOWNLOAD_FILE_LOCATION ]; then
    echo "File exists"
else 
    echo "File does not exist, downloading now..."
    wget -c https://www.zlib.net/zlib-$ZLIB_VERSION.tar.gz
fi
tar -xvzf zlib-$ZLIB_VERSION.tar.gz
cd zlib-$ZLIB_VERSION/
./configure --prefix=$ZLIB_INSTALL_DIRECTORY
make
make install
