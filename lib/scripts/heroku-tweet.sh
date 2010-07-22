#!/usr/bin/zsh

# Make sure we have a somewhat reasonable PATH
PATH="/usr/local/bin:/bin:/usr/bin:$PATH"

# Configuration
APP=crantastic

BITLY_USERNAME=[FILTERED]
BITLY_API_KEY=[FILTERED]

heroku rake crantastic:tweet --app $APP || exit 1
