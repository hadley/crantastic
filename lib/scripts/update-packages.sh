#!/bin/bash

# Make sure we have a somewhat reasonable PATH
PATH="/usr/local/bin:/bin:/usr/bin:$PATH"

cd crantastic

git reset --hard HEAD # avoids problems with git pull executing cleanly
git pull
sudo rake gems:install # makes sure latest gems are available

# Lets make sure that the password is set
export CRANTASTIC_PASSWORD=[FILTERED]
# And the hoptoad key, for errors
export HOPTOAD_API_KEY=[FILTERED]

RAILS_ENV=production rake crantastic:update_packages
