#!/usr/bin/zsh

# Make sure we have a somewhat reasonable PATH
PATH="/opt/ruby-enterprise/bin:/bin:/usr/bin:/usr/local/bin:$PATH"

# Configuration
APP=crantastic

heroku rake crantastic:create_weekly_digest --app $APP || exit 1
