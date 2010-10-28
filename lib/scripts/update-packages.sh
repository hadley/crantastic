#!/bin/bash

# Make sure we have a somewhat reasonable PATH
PATH="/usr/local/bin:/bin:/usr/bin:$PATH"

cd $HOME/crantastic

# Update to the latest available code
git pull

[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

RAILS_ENV=production rake crantastic:update_packages
