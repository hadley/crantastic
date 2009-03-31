# -*- coding: utf-8 -*-
require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
#require 'spec/rake/spectask'
require 'echoe'

desc 'Default: run unit tests.'
task :default => :test

Echoe.new('no_fuzz') do |p|
  p.author = "Bjørn Arild Mæland"
  p.email = "bjorn.maeland@gmail.com"
  p.summary = "No Fuzz"
  p.url = "http://www.github.com/Chrononaut/no_fuzz/"
  p.ignore_pattern = FileList[".gitignore"]
  p.include_rakefile = true
end

desc 'Test the no_fuzz plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

DOCUMENTED_FILES = FileList['README.markdown', 'MIT-LICENSE', 'lib/**/*.rb']

desc 'Generate documentation for the no_fuzz plugin.'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = "HostConnect"
  rdoc.options << '--line-numbers' << '--inline-source' << '--main' << 'README.markdown'
  rdoc.rdoc_files.include(*DOCUMENTED_FILES)
end
