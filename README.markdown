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
is used for documentation, whenever it feels necessary.

## Development

Ruby 1.8.7 is recommended (we use the latest Ruby Enterprise version on the live
site). 1.9.x will not work (yet).

Copy `config/database.sample.yml` to `config/database.yml`. It defaults to
SQLite, so no additional configuration of this file is necessary unless you want
to use MySQL (which the site runs on in production). It's important that the
encoding flag is set to utf8, or you'll run into subtle bugs.

We use bundler to manage gems, so simply run `bundle install` to install all
required gem dependencies.

Using `autospec` while doing changes to the source code is highly recommended,
as this is very helpful for catching accidental regressions.

Note that you should only add/edit stylesheets in the `app/stylesheets` folder.
`public/stylesheets` should only contain compiled Sass stylesheets.

### Solr

A connection to a Solr server is required for running the site. Note that the
version of `acts_as_solr` that is included in the repository is stripped down,
so it does not include the server part. Setting up a Solr server on your
development machine is simple, though:

* Install the Java runtime environment (not necessary on OSX). On Debian or
  Ubuntu this can be done with: sudo apt-get install sun-java6-jre
* git clone git://github.com/mattmatt/acts_as_solr.git
* cd acts_as_solr/solr && java -jar start.jar

Then you can run `rake solr:reindex` from the folder where you have the
crantastic source code.

### R package

There is a R package for crantastic that lives in its own branch in the Git
repository. Use the following steps to check out the source:

    git fetch origin R-package
    git checkout --track -b R-package origin/R-package

## Updating packages from CRAN

Run `rake crantastic:cron` or `rake crantastic:update_packages`. Look in the
`lib/scripts` folder for scripts and cron tasks.

## License

The crantastic source code is released under the MIT license, consult the
accompanying MIT-LICENSE file for details.
