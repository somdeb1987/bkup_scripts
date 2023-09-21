#!/bin/sh

set -e  # Exit immediately if a command fails

# Check if essential tools are available
command -v curl >/dev/null 2>&1 || { echo >&2 "curl is required but not installed. Aborting."; exit 1; }
command -v tar >/dev/null 2>&1 || { echo >&2 "tar is required but not installed. Aborting."; exit 1; }

# Default OpenMPI version and installation directory
DEFAULT_OPENMPI_VERSION="4.1.0"
DEFAULT_INSTALL_DIR="$HOME/.openmpi/v${DEFAULT_OPENMPI_VERSION}"

# Ask user for OpenMPI version
read -p "The default OpenMPI version is '$DEFAULT_OPENMPI_VERSION'. Please input a version if you wish to change (press Enter to use default): " OPENMPI_VERSION
# Use default if user input is empty
OPENMPI_VERSION=${OPENMPI_VERSION:-$DEFAULT_OPENMPI_VERSION}

# Generate download URL
DOWNLOAD_URL="https://download.open-mpi.org/release/open-mpi/v${OPENMPI_VERSION%.*}/openmpi-$OPENMPI_VERSION.tar.bz2"

# Check if the download URL is valid
if curl -I -f "$DOWNLOAD_URL" >/dev/null 2>&1; then
    echo "Download URL is valid. Proceeding with installation."
else
    echo "Invalid download URL. Aborting."
    exit 1
fi

# Ask user for OpenMPI installation directory
read -p "The default installation directory for OpenMPI is '$DEFAULT_INSTALL_DIR'. Please input a directory if you wish to change (press Enter to use default): " INSTALL_DIR
# Use default if user input is empty
INSTALL_DIR=${INSTALL_DIR:-$DEFAULT_INSTALL_DIR}

TMP_DIR="$(mktemp -d)"

# Download and extract OpenMPI
curl -o "$TMP_DIR/openmpi-$OPENMPI_VERSION.tar.bz2" "$DOWNLOAD_URL"
tar -jxf "$TMP_DIR/openmpi-$OPENMPI_VERSION.tar.bz2" -C "$TMP_DIR"

# Install OpenMPI
cd "$TMP_DIR/openmpi-$OPENMPI_VERSION"
./configure --prefix="$INSTALL_DIR"
make all
make install

# Cleanup
cd "$HOME"
rm -rf "$TMP_DIR"

# Add OpenMPI to the beginning of PATH and LD_LIBRARY_PATH in .bashrc if it exists
[ -f "$HOME/.bashrc" ] && {
  cp "$HOME/.bashrc" "$HOME/.bashrc.backup"  # Backup .bashrc
  echo "export PATH=$INSTALL_DIR/bin:\$PATH" >> "$HOME/.bashrc"
  echo "export LD_LIBRARY_PATH=$INSTALL_DIR/lib:\$LD_LIBRARY_PATH" >> "$HOME/.bashrc"
}

# Source .bashrc to apply changes for the current session if it exists
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

echo "OpenMPI $OPENMPI_VERSION has been installed successfully in $INSTALL_DIR."
