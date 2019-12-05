# THIS REPO IS ARCHIVED SINCE SLACK FINALLY ADDED IT'S OWN DARK MODE SUPPORT



# Dark theme for the slack 4 linux desktop app

## Requirements

- linux (send PR for Mac support)
- slack-desktop
- npm
- npx (the script will install it if necessary)
- asar (the script will install it if necessary)

Tested only on ubuntu-18.04. The package name `npm` might differ on your
platform. Install it by whatever name necessary.

## Install

Install slack first. If you haven't logged in for the first time, probably best
that you do. I've had intermittent problems otherwise.

Next, just run the script. It creates a working directory and uses `npm` to
install `npx` and `asar` locally and then uses them to extract app.asar and then
repack it after the javascript is added. It is fine to delete this working
directory when done, but the next update of slack will require re-installing
`npx` and `asar` so you might want to keep it around.

[comment]: <> ( vim: set tw=80 ts=4 sw=4 sts=4 et: )
