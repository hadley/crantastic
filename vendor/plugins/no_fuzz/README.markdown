# NoFuzz

Based on code and ideas in Steven Ruttenberg's nice blog entry "Live fuzzy
search using n-grams in Rails" [1].

Note that this family of fuzzy search techniques work best on dictionary-type
lookups, i.e not for large amounts of text.

kristian's acts_as_fuzzy_search [2] is a similar plugin, but it targets DataMapper.

1: http://unirec.blogspot.com/2007/12/live-fuzzy-search-using-n-grams-in.html
2: http://github.com/mkristian/kristians_rails_plugins/tree/master/act_as_fuzzy_search

# Basic Usage

Add the following code in the model you'd like to index:

  include NoFuzz
  fuzzy :field

Where field is the field used for the indexing data (you can use multiple fields
if you want).

Populate the index by running 'Model.populate_trigram_index'. Then, you can
search fuzzily with the fuzzy_find method:

  Model.fuzzy_find("query")
  Model.fuzzy_find("query", 10) # find maximum 10 rows

Copyright (c) 2009 Bjørn Arild Mæland, released under the MIT license
