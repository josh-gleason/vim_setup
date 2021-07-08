#!/bin/bash

if [[ $(hostname) = *.umiacs.umd.edu ]]; then
    # TODO prompt to install vim into different location
    . build_vim_umiacs.sh

    module purge
    module add cmake/3.16.2
    module add gcc/9.3.0
    module add Python3/3.8.2
    module add patchelf

    export PATH=/scratch1/$USER/Apps/vim-v8.2.2269/bin:$PATH
fi


VIM_VER=$(vim --version)
PY_PATH=$(which python)
if [[ ${VIM_VER} == *"+python3"* ]]; then
    PY_PATH=$(which python3)
elif [[ ${VIM_VER} == *"+python"* ]]; then
    PY_PATH=$(which python2)
fi

if [[ $(hostname) = *.umiacs.umd.edu ]]; then
    echo "UMIASC workstation detected. Using ${PY_PATH}"
else
    echo ""
    echo "IMPORTANT: Your vim needs to be compiled with python support (either 2 or 3),"
    echo "if compiled with python3 support then use python 3. Use \`vim --version\` to check."
    echo ""
    echo "Provide path to your python interpreter..."
    echo "Press Enter for the default: ${PY_PATH}"
    read -p '> ' PY_USER
    if [[ ! -z "${PY_USER}" ]]; then
        PY_PATH=${PY_USER}
    fi
fi

mkdir -p ${HOME}/.vim/bundle

echo "Copying colors"
rsync -rP colors ~/.vim/
if [ $? -ne 0 ]; then
    cp -rv colors ~/.vim/
fi

if test -f ${HOME}/.vim/bundle/Vundle.vim; then
    echo "Vundle already there"
else
    echo "Getting Vundle"
    git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim
fi

if test -f ${HOME}/.vimrc; then
    echo "${HOME}/.vimrc already exists, copying to ${HOME}/.vimrc.backup"
    cp -v ${HOME}/.vimrc ${HOME}/.vimrc.backup
fi

echo "creating ${HOME}/.vimrc"
${PY_PATH} util/replace_str.py vimrc ${HOME}/.vimrc "__PYTHON_INTERPRETER__" "${PY_PATH}"

vim +PluginInstall +qall

cd ${HOME}/.vim/bundle/YouCompleteMe && ${PY_PATH} install.py --clangd-completer

if [[ $(hostname) = *.umiacs.umd.edu ]]; then
    # Coolest tool ever. Replace needed library with absolute path to gcc/9.3.0 so that not dependent on LD_LIBRARY_PATH
    patchelf --replace-needed libgcc_s.so.1 /opt/local/stow/gcc-9.3.0/lib64/libgcc_s.so.1 "$HOME/.vim/bundle/YouCompleteMe/third_party/ycmd/third_party/clangd/output/bin/clangd"
    patchelf --replace-needed libstdc++.so.6 /opt/local/stow/gcc-9.3.0/lib64/libstdc++.so.6 "$HOME/.vim/bundle/YouCompleteMe/third_party/ycmd/third_party/clangd/output/bin/clangd"

    echo "Important!!! When you create a virtual environment or conda environment install flake8 and autopep8 to enable static code analysis in python"
    echo "Important!!! Add the following line to $HOME/.bashrc"
    echo "    export PATH=/scratch1/$USER/Apps/vim-v8.2.2269/bin:\$PATH"
else
    echo "Attempting to install flake8 and autopep8"
    ${PY_PATH} -m pip install --upgrade flake8 autopep8
fi


