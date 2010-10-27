#!/bin/bash

# Make sure we have a somewhat reasonable PATH
PATH="/usr/local/bin:/bin:/usr/bin:$PATH"

cd ~/crantastic

git pull

RAILS_ENV=production rake crantastic:update_packages
