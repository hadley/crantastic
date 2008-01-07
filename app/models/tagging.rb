class Tagging < ActiveRecord::Base
  belongs_to :user
  belongs_to :package
  
  def self.tags
    connection.execute "SELECT DISTINCT tag, count(*) as count FROM tagging"
  end
  
end
