#!/usr/bin/env bash

# The npm version from ubuntu 14.04 has broken CA certificates. It also does not
# install a "node" command. Just a "nodejs" command. This is needed by current
# npx versions.

set -eE

# Ubuntu 14.04 needs some changes to npm/node
function detect_os() {
  if ! command -v lsb_release &>/dev/null; then
    if [ -f '/etc/centos-release' ]; then
      IFS=' ' read -ra _array < /etc/centos-release
      for i in "${_array[@]}"; do
        if [[ $i =~ ^[0-9.]+$ ]]; then
          _ver="$i"
          break
        fi
      done
      _maj="$(cut -d. -f1 <<<"$_ver")"
      _os="centos${_maj}"
    fi
  else
    _dist="$(lsb_release -is)"
    _ver="$(lsb_release -rs)"
    # Mint 17 is ubuntu 14.04. Later Mint versions unsupported as Mint is unsafe.
    if [ "$_dist" == "LinuxMint" ] && [[ "$_ver" =~ ^17.[0-9]+$ ]]; then
      _os="ubuntu1404"
    elif [ "$_dist" == "Ubuntu" ]; then
      if [ "$_ver" == '18.04' ]; then
        _os="ubuntu1804"
      fi
    fi
  fi
}
function install_npm() {
  if ! command -v npm &>/dev/null; then
    sudo apt-get install -y npm
    if [ "$_os" == 'ubuntu1404' ]; then
      sudo patch -Np0 -i "${basedir:?}/update-root-ca-certs.patch" \
        -d /usr/share/npm/node_modules/npmconf
    fi
  fi
}

function install_n() {
  if ! command -v n &>/dev/null; then
    npm i n
  fi
}

function install_node() {
  if ! command -v node &>/dev/null; then
    if [ "$_os" == 'ubuntu1404' ]; then
      install_n
      N_PREFIX="${wd:?}" n lts
      _nodebin="$(dirname "$(N_PREFIX="$wd" n which lts)")"
      PATH="${_nodebin}:${PATH}"
    else
      echo "This script doesn't yet support custom node installation"
      exit 1
    fi
  fi
}

function install_npx() {
  if ! command -v npx &>/dev/null; then
    npm i npx
  fi
}

function install_asar() {
  if ! command -v asar &>/dev/null; then
    npm i asar 2>/dev/null
  fi
}

# vim: set tw=80 ts=2 sw=2 sts=2 et:
