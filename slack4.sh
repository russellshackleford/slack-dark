#!/usr/bin/env bash

wd="${HOME}/.__slack_theming"
mkdir -p "$wd"
pushd "$wd" &>/dev/null

bindir="${wd}/node_modules/.bin"
PATH="${bindir}:${PATH}"

if ! command -v npx &>/dev/null; then
  npm i npx
fi

if ! command -v asar &>/dev/null; then
  npm i asar
fi

JS="
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

echo "Adding Dark Theme Code to Slack... "

sudo ${bindir}/npx asar extract ${resources}/app.asar{,.unpacked}
sudo tee -a "${jsfile}" > /dev/null <<< "$JS"
sudo ${bindir}/npx asar pack ${resources}/app.asar{.unpacked,}

# vim: set ts=2 sw=2 sts=2 et:
