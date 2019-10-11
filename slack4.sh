#!/usr/bin/env bash

set -e

basedir="$(readlink -e "$(dirname "$0")")"
wd="${HOME}/.__slack_theming"
bindir="${wd}/node_modules/.bin"
PATH="${bindir}:${PATH}"

# Ensure slack is installed
_version="$(dpkg -s slack-desktop |grep ^Version |awk '{print $2}')"
if [ -z "$_version" ]; then
  echo "Cannot determine slack version. Is it installed?"
  exit 1
fi

mkdir -p "$wd"
# shellcheck source=install-tools.sh
. "${basedir}/install-tools.sh"

pushd "$wd" &>/dev/null
detect_os
install_npm
install_node
install_npx
install_asar

js="
// First make sure the wrapper app is loaded
document.addEventListener('DOMContentLoaded', function() {
  // Fetch our CSS in parallel ahead of time
  const cssPath = 'https://raw.githubusercontent.com/russellshackleford/slack-dark/master/slack4.css';
  let cssPromise = fetch(cssPath).then((response) => response.text());

  // Insert a style tag into the wrapper view
  cssPromise.then((css) => {
    let s = document.createElement('style');
    s.type = 'text/css';
    s.innerHTML = css;
    document.head.appendChild(s);
  });
});"

resources="/usr/lib/slack/resources"
jsfile="${resources}/app.asar.unpacked/dist/ssb-interop.bundle.js"

if [ ! -f "${resources}/dark-mode-${_version}-enabled" ]; then
  echo -e "\\nAdding Dark Theme Code to Slack... "
  sudo bash -c "export PATH=$PATH; \
                npx asar extract \
                  ${resources}/app.asar{,.unpacked}"
  sudo tee -a "${jsfile}" > /dev/null <<< "$js"
  sudo bash -c "export PATH=$PATH; \
                npx asar pack ${resources}/app.asar{.unpacked,}"
  sudo touch "${resources}/dark-mode-${_version}-enabled"
else
  echo -e "\\nIt appears you have already applied the dark theme"
fi

# vim: set ts=2 sw=2 sts=2 et:
