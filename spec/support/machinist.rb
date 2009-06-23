require File.expand_path(File.dirname(__FILE__) + "/../blueprints")

Spec::Runner.configure { |config| config.before(:each) { Sham.reset } }

class ActiveRecord::Base
  def self.make_unvalidated(*args)
    self.make_unsaved(*args).save(false)
  end
end
