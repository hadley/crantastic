#!/usr/bin/zsh

# Make sure we have a somewhat reasonable PATH
PATH="/usr/local/bin:/bin:/usr/bin:$PATH"

cd $HOME/crantastic

[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

RAILS_ENV=production rake crantastic:update_taskviews
