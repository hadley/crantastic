# Crantastic

The project is described [here](http://dev.crantastic.org/about). Some other
links of interests are:

- [Crantastic](http://crantastic.org/)
- [Development blog](http://blog.crantastic.org/)
- [User Voice](http://crantastic.uservoice.com/)

The rest of this document contains various pieces of information relevant for
developers/contributors.

## Coding conventions

The [YARD](http://github.com/lsegal/yard/tree/master) meta-tag formatting format
is usued for documentation, whenever it feels necessary.

## Development dependencies

Run `sudo rake gems:install` to install all gem dependencies.

Note that you should only add/edit stylesheets in the `app/stylesheets` folder.
`public/stylesheets` should only contain compiled Sass styhesleets.

## Working with Heroku

### Setting up the Heroku remote

    git remote add heroku git@heroku.com:crantastic.git

Confirm that it's working by running `heroku info`.

### Pulling the latest database from crantastic.org

    heroku db:pull

This will overwrite `db/development.sqlite3`.

## Updating packages from CRAN

Add the following line to your crontab to automatically update crantastic ever
four hours when CRAN is actively being updated.

    18 5,9,13,17 * * *  hadley  cd /home/hadley/public/crantastic.org/lib/r && ./run-update.r
