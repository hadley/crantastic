# == Schema Information
#
# Table name: review_comment
#
#  id         :integer(4)      not null, primary key
#  review_id  :integer(4)      not null
#  user_id    :integer(4)      not null
#  title      :string(45)      not null
#  comment    :text            default(""), not null
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReviewComment do

end
