#!/bin/bash
module purge
module add Python3/3.8.2
module add gcc/9.3.0
module add cmake/3.16.2

git clone https://github.com/vim/vim.git
cd vim
git checkout v8.2.2269

# https://github.com/ycm-core/YouCompleteMe/issues/3522
export LDFLAGS="-rdynamic -L/opt/local/stow/Python3-3.8.2/lib/"
export CPPFLAGS="-I/opt/local/stow/Python3-3.8.2/include/python3.8"
export CONFIG_OPTS="--with-features=huge --enable-multibyte --enable-python3interp=yes --with-python3-config-dir=/opt/local/stow/Python3-3.8.2/lib/python3.8/config-3.8-x86_64-linux-gnu"

./configure $CONFIG_OPTS --prefix=/scratch1/$USER/Apps/vim-v8.2.2269
make -j32
make install
make install prefix=/fs/diva-scratch/$USER/local/vim-v8.2.2269
