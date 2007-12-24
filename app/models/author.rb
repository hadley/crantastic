class Author < ActiveRecord::Base
  has_many :versions, :foreign_key => :maintainer_id
  
  def Author.find_or_create(name = nil, email = nil) 
    author = Author.find_by_email(email) || Author.find_by_name(name)
    
    return author if author
    
    Author.create(:name => name, :email => email)  
  end
  
  def Author.new_from_string(string)
    return Author.find_or_create_by_name("Unknown") if string.blank?
    
    name, email = string.split(/[<>]/).map(&:strip)
    if name =~ /@/
      email = name
      name = nil
    end
    
    email.downcase! unless email.blank?
    
    Author.find_or_create(name, email)
  end
  
end
