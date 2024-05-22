#!/usr/bin/env bash

set -e

show_usage() {
  echo "Usage: $(basename $0) takes exactly 1 argument (install | uninstall)"
}

if [ $# -ne 1 ]
then
  show_usage
  exit 1
fi

check_env() {
  if [[ -z "${RALPM_TMP_DIR}" ]]; then
    echo "RALPM_TMP_DIR is not set"
    exit 1
  
  elif [[ -z "${RALPM_PKG_INSTALL_DIR}" ]]; then
    echo "RALPM_PKG_INSTALL_DIR is not set"
    exit 1
  
  elif [[ -z "${RALPM_PKG_BIN_DIR}" ]]; then
    echo "RALPM_PKG_BIN_DIR is not set"
    exit 1
  fi
}

install() {
  wget https://github.com/indygreg/python-build-standalone/releases/download/20220802/cpython-3.10.6+20220802-x86_64-unknown-linux-gnu-install_only.tar.gz -O $RALPM_TMP_DIR/cpython-3.10.6.tar.gz
  tar xf $RALPM_TMP_DIR/cpython-3.10.6.tar.gz -C $RALPM_PKG_INSTALL_DIR
  rm $RALPM_TMP_DIR/cpython-3.10.6.tar.gz

  $RALPM_PKG_INSTALL_DIR/python/bin/pip3.10 install https://github.com/RAL0S/expliot/releases/download/v0.9.11/bluepy-1.3.0-cp310-cp310-linux_x86_64.whl
  $RALPM_PKG_INSTALL_DIR/python/bin/pip3.10 install libusb
  $RALPM_PKG_INSTALL_DIR/python/bin/pip3.10 install expliot==0.9.11

  ln -s $RALPM_PKG_INSTALL_DIR/python/bin/expliot $RALPM_PKG_BIN_DIR/

  echo "This package adds the commands:"
  echo " - expliot"
}

uninstall() {
  rm -rf $RALPM_PKG_BIN_DIR/python
  rm $RALPM_PKG_BIN_DIR/expliot
}

run() {
  if [[ "$1" == "install" ]]; then 
    install
  elif [[ "$1" == "uninstall" ]]; then 
    uninstall
  else
    show_usage
  fi
}

check_env
run $1