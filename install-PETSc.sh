#!/bin/bash
#============================================================
# Collect user inputs for all options at the beginning
# run it as "./install-PETSc.sh" or "bash install-PETSc.sh"
#============================================================
# DO NOT run it as "sh install-PETSc.sh" or you will get error
# The sh command invokes a POSIX-compliant shell, which may not 
# support all Bash-specific features. This could lead to unexpected 
# behavior or errors when running the script.
#============================================================
# Default paths and architecture

# Automatically detect the MPI directory
MPI_BIN_PATH=$(which mpicc)
if [ -n "$MPI_BIN_PATH" ]; then
    # Extract the directory path from the MPI binary path
    DEFAULT_MPI_DIR=$(dirname $(dirname $MPI_BIN_PATH))
else
    # Fallback to a predefined default if 'which mpicc' doesn't return anything
    DEFAULT_MPI_DIR="$HOME/.openmpi/v4.1.5"
fi

# Ask user for OpenMPI directory
read -p "The detected path for OpenMPI is '$DEFAULT_MPI_DIR'. Please input a path if you wish to change (press Enter to use default): " MPI_DIR
# Use default if user input is empty
MPI_DIR=${MPI_DIR:-$DEFAULT_MPI_DIR}


DEFAULT_PETSC_PATH="$HOME/libraries/petsc"
DEFAULT_PETSC_ARCH="arch-linux2-c-debug"

# Ask user for PETSc installation path
read -p "The default installation path for PETSc is '$DEFAULT_PETSC_PATH'. Please input a path if you wish to change (press Enter to use default): " PETSC_PATH
# Use default if user input is empty
PETSC_PATH=${PETSC_PATH:-$DEFAULT_PETSC_PATH}

# Ask user for PETSc architecture
read -p "The default PETSc architecture is '$DEFAULT_PETSC_ARCH'. Please input an architecture if you wish to change (press Enter to use default): " PETSC_ARCH
# Use default if user input is empty
PETSC_ARCH=${PETSC_ARCH:-$DEFAULT_PETSC_ARCH}

# Install dependencies
sudo apt install cmake bison flex

# Create libraries directory if it doesn't exist
mkdir -p $(dirname $PETSC_PATH)
cd $(dirname $PETSC_PATH)

# Check if PETSc directory exists
if [ -d "$PETSC_PATH" ]; then
    read -p "Directory $PETSC_PATH exists. Do you want to update it? (y/n): " choice
    if [[ $choice == "y" || $choice == "Y" ]]; then
        cd $PETSC_PATH
        git pull || { echo "Failed to update PETSc repository."; exit 1; }
    else
        echo "Exiting without updating."
        exit 0
    fi
else
    git clone -b release https://gitlab.com/petsc/petsc.git $PETSC_PATH || { echo "Failed to clone PETSc repository."; exit 1; }
    cd $PETSC_PATH
fi

# Configure and build PETSc
python config/configure.py build \
    --with-mpi-dir=$MPI_DIR \
    --download-fblaslapack=1 \
    --download-superlu_dist \
    --download-parmetis \
    --download-metis \
    --download-mumps \
    --download-scalapack \
    --download-ptscotch \
    --download-hypre \
    --download-ml=1 \
    --with-shared-libraries

# Compile PETSc
make PETSC_DIR=$PETSC_PATH PETSC_ARCH=$PETSC_ARCH all
