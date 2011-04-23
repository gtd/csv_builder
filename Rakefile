require 'rake/rdoctask'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'jeweler'

desc 'Generate documentation for the csv_builder plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'CSV Builder'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('CHANGELOG.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Test the csv builder'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern   = "./spec/**/*_spec.rb"
end

desc 'Default: run specs.'
task :default => :spec

Jeweler::Tasks.new do |gem|
  gem.name = "csv_builder"
  gem.homepage = "http://github.com/dasil003/csv_builder"
  gem.license = "MIT"
  gem.summary = %Q{CSV template handler for Rails}
  gem.description = %Q{CSV template handler for Rails.  Enables :format => 'csv' in controllers, with templates of the form report.csv.csvbuilder.}
  gem.email = "gabe@websaviour.com"
  gem.authors = ['Econsultancy', 'Vidmantas Kabosis', "Gabe da Silveira"]

  gem.files.exclude 'spec'
end
Jeweler::RubygemsDotOrgTasks.new
