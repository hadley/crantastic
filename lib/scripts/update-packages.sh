#!/bin/bash

# Make sure we have a somewhat reasonable PATH
PATH="/usr/bin:/usr/local/bin:$PATH"

cd crantastic

git pull

# Lets make sure that the password is set
export CRANTASTIC_PASSWORD=[FILTERED]
# And the hoptoad key, for errors
export HOPTOAD_API_KEY=[FILTERED]

RAILS_ENV=production rake crantastic:update_packages
