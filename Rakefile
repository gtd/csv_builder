require 'rdoc/task'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'jeweler'

desc 'Generate documentation for the csv_builder plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'CSV Builder'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.md')
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

  gem.add_dependency 'actionpack', '>=3.0.0'

  gem.add_development_dependency 'rails', '>= 3.0.0'
  gem.add_development_dependency 'rspec', '~> 2.5'
  gem.add_development_dependency 'rspec-rails', '~> 2.5'
  gem.add_development_dependency 'jeweler'
  gem.add_development_dependency 'rack'
  gem.add_development_dependency 'sqlite3'

  gem.requirements << 'iconv'
  gem.requirements << 'Ruby 1.9.x or FasterCSV'
end
Jeweler::RubygemsDotOrgTasks.new
