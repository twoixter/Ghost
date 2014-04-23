#!/bin/sh

## Check for re-entrancy
if [ ! -z $_HOSTING_INSTALL_REENTRANCY ]; then 
    exit 0
fi

## Setup config.js
if [ ! -L "./config.js" ] && [ ! -f "./config.js" ]; then
    ln -s config.hosting.js config.js || exit 1
fi

## Install Bourbon
export GEM_HOME=./node_modules/.gem/ruby/1.9.1
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
PATH="$GEM_HOME/bin:$PATH"
gem install bourbon sass --no-rdoc --no-ri || exit 2

## Install Dev dependencies (package.json)
export _HOSTING_INSTALL_REENTRANCY=1
npm install
npm install grunt-cli

## Run Grunt init tasks
if [ ! -d './core/client/assets/sass/modules/bourbon' ]; then
    ./node_modules/.bin/grunt shell:bourbon prod
else
    ./node_modules/.bin/grunt prod
fi

