# encoding: UTF-8
require "bundler/gem_tasks"
require 'rake/testtask'
require 'rdoc/task'

desc 'Default: run tests for all ORMs.'
task default: :test

desc 'Run Rygsaek tests for all ORMs.'
task :pre_commit do
  Dir[File.join(File.dirname(__FILE__), 'test', 'orm', '*.rb')].each do |file|
    orm = File.basename(file).split(".").first
    # "Some day, my son, rake's inner wisdom will reveal itself.  Until then,
    # take this `system` -- may its brute force protect you well."
    exit 1 unless system "rake test RYGSAEK_ORM=#{orm}"
  end
end

desc 'Run Rygsaek unit tests.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
  t.warning = false
end

desc 'Generate documentation for Rygsaek.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Rygsaek'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
