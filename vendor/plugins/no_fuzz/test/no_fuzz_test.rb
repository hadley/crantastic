require File.dirname(__FILE__) + '/test_helper.rb'
require 'rails_generator'
require 'rails_generator/scripts/generate'
require 'generators/no_fuzz/no_fuzz_generator'

class NoFuzzTest < ActiveSupport::TestCase

  load_schema

  class PackageTrigram < ActiveRecord::Base
  end

  class Package < ActiveRecord::Base
    include NoFuzz

    fuzzy :name
  end

  def test_populating_and_deleting_trigram_index
    Package.create!(:name => "abcdef")
    Package.populate_trigram_index
    assert_equal 5, PackageTrigram.count
    Package.clear_trigram_index
    assert_equal 0, PackageTrigram.count
  end

end

class GeneratorHelpersTest < Test::Unit::TestCase
  include GeneratorHelpers

  def test_graceful_pluralization
    ActiveRecord::Base.pluralize_table_names = false
    assert_equal "chicken", gracefully_pluralize("chicken")
    ActiveRecord::Base.pluralize_table_names = true
    assert_equal "chickens", gracefully_pluralize("chicken")
  end
end
