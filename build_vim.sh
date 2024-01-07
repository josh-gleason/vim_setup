#!/bin/bash

set -e
set -o pipefail

VIM_REPO="https://github.com/vim/vim.git"
VIM_VERSION="v9.1.0015"
PYTHON_VERSION="3.10"
INSTALL_PREFIX="${HOME}/.local"  # Define the installation prefix here

TEMP_DIR=$(mktemp -d)
CURRENT_DIR=$(pwd)

cd "${TEMP_DIR}"

touch "${TEMP_DIR}/build.log"

handle_error() {
    cp "${TEMP_DIR}/build.log" "${CURRENT_DIR}/vim_build.log"
    echo "An error occurred. Check build.log in ${CURRENT_DIR} for details."
    exit 1
}
trap 'handle_error' ERR

git clone "${VIM_REPO}" vim
cd vim
git checkout "${VIM_VERSION}"

set -x

export LDFLAGS="-rdynamic $(python${PYTHON_VERSION}-config --ldflags)"
export CPPFLAGS="$(python${PYTHON_VERSION}-config --cflags)"
PYTHON_CONFIG_DIR=$(python${PYTHON_VERSION}-config --configdir)
export CONFIG_OPTS="--with-features=huge --enable-multibyte --enable-python3interp=yes --with-python3-config-dir=${PYTHON_CONFIG_DIR}"

{
    ./configure ${CONFIG_OPTS} --prefix="${INSTALL_PREFIX}"
    make -j$(nproc)
    make install
} &> "${TEMP_DIR}/build.log"

rm -rf "${TEMP_DIR}"

echo "Vim installation complete."
