#!/bin/bash

PY2_PATH=$(which python2)
echo ""
echo "IMPORTANT: Your vim needs to be compiled with python support (either 2 or 3),"
echo "if compiled with python3 support then use python 3. Use \`vim --version\` to check."
echo ""
echo "Provide path to your python interpreter..."
echo "Press Enter for the default: ${PY2_PATH}"
read -p '> ' PY2_USER
if [[ ! -z "$PY2_USER" ]]; then
    PY2_PATH=$PY2_USER
fi

mkdir -p ${HOME}/.vim/bundle

echo "Copying colors"
rsync -rP colors ~/.vim/

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
$PY2_PATH util/replace_str.py vimrc ${HOME}/.vimrc "__PYTHON2_INTERPRETER__" "${PY2_PATH}"

vim +PluginInstall +qall

cd ${HOME}/.vim/bundle/YouCompleteMe && python2 install.py --clang-completer

