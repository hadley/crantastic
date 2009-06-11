# UTF-8
unless RUBY_VERSION =~ /1.9/
  $KCODE = 'u'
  require 'jcode'
end
