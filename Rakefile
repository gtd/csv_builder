require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the csv_builder plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the csv_builder plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'CSV Builder'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('CHANGELOG.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'spec/rake/spectask'
rescue LoadError
  begin
    gem 'rspec-rails', '>= 1.0.0'
    require 'spec/rake/spectask'
  rescue LoadError
    puts "[csv builder:] RSpec - or one of it's dependencies - is not available. Install it with: sudo gem install rspec-rails"
  end
end

if defined?(Spec)
  desc 'Test the formtastic plugin.'
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts = ["-c"]
  end
end
