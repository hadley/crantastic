#!/usr/bin/zsh

# Make sure we have a somewhat reasonable PATH
PATH="/bin:/usr/bin:/usr/local/bin:$PATH"

# Configuration
APP=crantastic

heroku rake crantastic:update_taskviews --app $APP || exit 1
