require File.expand_path(File.dirname(__FILE__) + "/../blueprints")

Spec::Runner.configure { |config| config.before(:each) { Sham.reset } }
