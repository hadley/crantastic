# No Fuzz
## Simple Rails-plugin that provides offline fuzzy-search for ActiveRecord

Simple as can be fuzzy search. Works with any database supported by Active
Record. No dependencies. The notion of being offline means that it creates an
index which the search algorithm leverages. Note that this index has to be
updated to reflect changes in the database content. The plugin creates a
separate database model for the index. This means that no changes will be made
to your existing schema.

Note that this family of fuzzy search techniques work best on dictionary-type
lookups (names, words, etc).

The plugin is based on code and ideas in Steven Ruttenberg's nice blog entry
["Live fuzzy search using n-grams in Rails"](http://unirec.blogspot.com/2007/12/live-fuzzy-search-using-n-grams-in.html).

kristian's
[acts_as_fuzzy_search](http://github.com/mkristian/kristians_rails_plugins/tree/master/act_as_fuzzy_search)
is a similar plugin, but it targets DataMapper.

## Installation and Setup

No Fuzz as a plugin:

    cd your_rails_project
    script/plugin install git://github.com/Chrononaut/no_fuzz.git
    # Now we create a trigram migration for the model we want to add fuzzy search to:
    script/generate no_fuzz Model
    rake db:migrate
    
Or if you want to use is as a gem:
    
    gem sources -a http://gems.github.com
    sudo gem install Chrononaut-no_fuzz 

Then add the following line to your environment.rb file

    config.gem "Chrononaut-no_fuzz", :source => "http://gems.github.com", :lib => "no_fuzz"


## Basic Usage

Add the following code in the model you'd like to index:

    include NoFuzz
    fuzzy :field

Where field is the field used for the indexing data (you can use multiple fields
if you want).

Populate the index by running:

    Model.populate_trigram_index

Then, you can search fuzzily with the fuzzy_find method:

    Model.fuzzy_find("query")
    Model.fuzzy_find("query", 10) # find maximum 10 rows

A concrete example from a real app can look like this:

    >> Contractor.fuzzy_find('johm')
    => [#<Contractor id: 1, full_name: "John Doe", created_at: "2009-04-30 10:05:02", updated_at: "2009-04-30 10:05:02">]

## Contributors

The following people have submitted changes which have been applied to the core:

* [Bjørn Arild Mæland](http://github.com/Chrononaut)
* [Shoaib Burq](http://github.com/sabman)

Copyright (c) 2009 Bjørn Arild Mæland, released under the MIT license
