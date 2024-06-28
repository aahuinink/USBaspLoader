#!/usr/bin/bash

set -e 

echo "Setting env variables"

PREFIX=$HOME/local/avr
mkdir -p $PREFIX
mkdir $PREFIX/bin
export PREFIX 
PATH=$PATH:$PREFIX/bin
export PATH

echo "PATH env variables set"

echo "Installing binutils"
cd $PREFIX

# TODO: ADD VERSION CONTROL
    # GET NEW VERSION FROM USER
    # REMOVE OLD VERSIONS

BINUTIL_VERSION="2.42"

# prereqs
sudo apt install texinfo

echo "Getting binutils-$VERSION"

curl https://ftp.gnu.org/gnu/binutils/binutils-$VERSION.tar.gz --output "binutils-$VERSION.tar.gz"
gunzip binutils-$VERSION.tar.gz
tar -xf binutils-$VERSION.tar
cd binutils-$VERSION
mkdir obj-avr
cd obj-avr
echo "Configuring binutils-$VERSION"
../configure --prefix=$PREFIX --target=avr --disable-nls
echo "Running make file"
make clean
make
make install



# Installing GCC for AVR target
cd $PREFIX
GCC_VERSION="14.1.0"
curl https://mirror.csclub.uwaterloo.ca/gnu/gcc/gcc-14.1.0/gcc-14.1.0.tar.gz --output gcc-14.1.0.tar.gz
gunzip gcc-14.1.0.tar.gz
tar -xf gcc-14.1.0.tar
cd gcc-14.1.0
echo "Downloading PREREQS:"
./contrib/download_prerequisites
mkdir obj-avr
cd obj-avr
../configure --prefix=$PREFIX --target=avr --enable-languages=c,c++ --disable-nls --disable-libssp --with-dwarf2
make -j2
make -j2 install

# AVR-libc tool
apt install autoconf
apt install automake
cd $PREFIX
git clone https://github.com/avrdudes/avr-libc.git
cd avr-libc
./bootstrap
cd devtools
./configure --prefix=$PREFIX --build=`./config.guess` --host=avr
make -j2
make -j2 install