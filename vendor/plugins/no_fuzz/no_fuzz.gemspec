# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{no_fuzz}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bj\303\270rn Arild M\303\246land"]
  s.date = %q{2009-04-30}
  s.description = %q{No Fuzz}
  s.email = %q{bjorn.maeland@gmail.com}
  s.extra_rdoc_files = ["README.markdown", "tasks/no_fuzz_tasks.rake", "lib/no_fuzz.rb", "CHANGELOG"]
  s.files = ["Rakefile", "README.markdown", "no_fuzz.gemspec", "tasks/no_fuzz_tasks.rake", "init.rb", "lib/no_fuzz.rb", "generators/no_fuzz/USAGE", "generators/no_fuzz/templates/migration.rb", "generators/no_fuzz/templates/model.rb", "generators/no_fuzz/no_fuzz_generator.rb", "MIT-LICENSE", "install.rb", "test/no_fuzz_test.rb", "test/database.yml", "test/schema.rb", "test/test_helper.rb", "rails/init.rb", "CHANGELOG", "uninstall.rb", "Manifest"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/Chrononaut/no_fuzz}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "No_fuzz", "--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{no_fuzz}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{No Fuzz}
  s.test_files = ["test/no_fuzz_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
