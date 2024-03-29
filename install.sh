#!/bin/bash

VIM_VER=$(vim --version)
PY_PATH=$(which python)
if [[ ${VIM_VER} == *"+python3"* ]]; then
    PY_PATH=$(which python3)
elif [[ ${VIM_VER} == *"+python"* ]]; then
    PY_PATH=$(which python2)
fi

echo ""
echo "IMPORTANT: Your vim needs to be compiled with python 3 support"
echo "Use \`vim --version\` to check."
echo ""
echo "Provide path to your python interpreter..."
echo "Press Enter for the default: ${PY_PATH}"
read -p '> ' PY_USER
if [[ ! -z "${PY_USER}" ]]; then
    PY_PATH=${PY_USER}
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

cd ${HOME}/.vim/bundle/YouCompleteMe && ${PY_PATH} install.py --clangd-completer --rust-completer

if test -f ${HOME}/.config/flake8; then
    echo "${HOME}/.config/flake8 already exists"
else
    echo "installing flake8 config to ${HOME}/.config/flake8"
    mkdir -p ${HOME}/.config
    cp -v flake8 ${HOME}/.config/flake8
fi

echo "Attempting to install flake8 and autopep8"
${PY_PATH} -m pip install --upgrade flake8 autopep8

asdf
