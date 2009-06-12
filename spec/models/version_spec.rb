require File.dirname(__FILE__) + '/../spec_helper'

describe Version do

  should_allow_values_for :title, "Title", ""

  should_validate_length_of :name, :minimum => 2, :maximum => 255
  should_validate_length_of :version, :minimum => 1, :maximum => 25
  should_validate_length_of :title, :minimum => 0, :maximum => 255
  should_validate_length_of :url, :minimum => 0, :maximum => 255

end
