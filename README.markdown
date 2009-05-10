# Crantastic

## Working with Heroku

### Setting up the Heroku remote

    git remote add heroku git@heroku.com:crantastic.git

Confirm that it's working by running 'heroku info'.

### Pulling the latest database from crantastic.org

    heroku db:pull

This will overwrite db/development.sqlite3.

## Updating packages from CRAN

Add the following line to your crontab to automatically update crantastic ever
four hours when CRAN is actively being updated.

    18 5,9,13,17 * * *  hadley  cd /home/hadley/public/crantastic.org/lib/r && ./run-update.r
