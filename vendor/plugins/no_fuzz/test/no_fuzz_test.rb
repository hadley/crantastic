require File.dirname(__FILE__) + '/test_helper.rb'

class NoFuzzTest < ActiveSupport::TestCase

  load_schema

  class Package < ActiveRecord::Base
  end

  class PackageTrigram < ActiveRecord::Base
  end

  def test_schema_has_loaded_correctly
    assert_equal [], Package.all
    assert_equal [], PackageTrigram.all
  end

end
