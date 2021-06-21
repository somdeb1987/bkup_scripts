sudo apt install cmake
sudo apt install bison
sudo apt install flex
mkdir -p $HOME/libraries
cd $HOME/libraries
if [ -d $HOME"/libraries/petsc" ] 
then
    echo "Directory "$HOME"/libraries/petsc exists." 
    cd petsc
    git pull
else
    echo "Error: Directory $HOME/libraries/petsc does not exists."
    git clone -b release https://gitlab.com/petsc/petsc.git petsc
    cd petsc
fi
python config/configure.py build \
    --with-mpi-dir=$HOME/.openmpi \
    --download-fblaslapack=1 \
    --download-superlu_dist \
    --download-parmetis \
    --download-metis \
    --download-mumps \
    --download-scalapack \
    -download-ptscotch \
    --download-hypre \
    --download-ml=1 \
    --with-shared-libraries
make PETSC_DIR=/home/somdeb/libraries/petsc PETSC_ARCH=arch-linux2-c-debug all
