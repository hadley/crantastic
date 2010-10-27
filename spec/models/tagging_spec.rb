# == Schema Information
#
# Table name: tagging
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  package_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  tag_id     :integer(4)
#

require File.dirname(__FILE__) + '/../spec_helper'

describe Tagging do
end
