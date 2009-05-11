Dir[File.dirname(__FILE__) + '/lib/sevenwire/**/*'].each do |file_name|
  require file_name
end
