#!/bin/sh

set -e  # Exit immediately if a command fails

# Check if essential tools are available
command -v curl >/dev/null 2>&1 || { echo >&2 "curl is required but not installed. Aborting."; exit 1; }
command -v tar >/dev/null 2>&1 || { echo >&2 "tar is required but not installed. Aborting."; exit 1; }

# Default HDF5 version and installation directory
DEFAULT_HDF5_VERSION="1.12.0"  # Change this to your preferred version
DEFAULT_INSTALL_DIR="$HOME/libraries/hdf5/v${DEFAULT_HDF5_VERSION}"

# Ask user for HDF5 version
read -p "Default HDF5 version is '$DEFAULT_HDF5_VERSION'. Enter a version to change (press Enter for default): " HDF5_VERSION
HDF5_VERSION=${HDF5_VERSION:-$DEFAULT_HDF5_VERSION}

HDF5_SERIES=$(echo "$HDF5_VERSION" | cut -d. -f1,2)

# Generate download URL
DOWNLOAD_URL="https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-$HDF5_SERIES/hdf5-$HDF5_VERSION/src/hdf5-$HDF5_VERSION.tar.gz"

# Validate download URL
if curl -I -f "$DOWNLOAD_URL" >/dev/null 2>&1; then
    echo "Download URL is valid. Proceeding with installation."
else
    echo "Invalid download URL. Aborting."
    exit 1
fi

# Ask user for HDF5 installation directory
read -p "Default installation directory for HDF5 is '$DEFAULT_INSTALL_DIR'. Enter a directory to change (press Enter for default): " INSTALL_DIR
INSTALL_DIR=${INSTALL_DIR:-$DEFAULT_INSTALL_DIR}

TMP_DIR="$(mktemp -d)"

# Download and extract HDF5
curl -o "$TMP_DIR/hdf5-$HDF5_VERSION.tar.gz" "$DOWNLOAD_URL"
tar -zxf "$TMP_DIR/hdf5-$HDF5_VERSION.tar.gz" -C "$TMP_DIR"

# Install HDF5
cd "$TMP_DIR/hdf5-$HDF5_VERSION"
CC=mpicc FC=mpif90 \
  CFLAGS=-fPIC ./configure \
  --enable-shared --enable-parallel \
  --enable-fortran --enable-fortran2003 \
  --prefix=$INSTALL_DIR
make
#make all
make install

# Cleanup
cd "$HOME"
rm -rf "$TMP_DIR"

# Update PATH and LD_LIBRARY_PATH in .bashrc
[ -f "$HOME/.bashrc" ] && {
  cp "$HOME/.bashrc" "$HOME/.bashrc.backup"
  echo "export PATH=$INSTALL_DIR/bin:\$PATH" >> "$HOME/.bashrc"
  echo "export LD_LIBRARY_PATH=$INSTALL_DIR/lib:\$LD_LIBRARY_PATH" >> "$HOME/.bashrc"
}


# Source .bashrc to apply changes for the current session
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

echo "HDF5 $HDF5_FILE_NAME has been installed successfully in $INSTALL_DIR."
  
