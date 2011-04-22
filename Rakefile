require 'rake'
require 'rake/rdoctask'

begin
  require 'rspec/core'
  require 'rspec/core/rake_task'
rescue MissingSourceFile
  module RSpec
    module Core
      class RakeTask
        def initialize(name)
          task name do
            # if rspec-rails is a configured gem, this will output helpful material and exit ...
            require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
            # ... otherwise, do this:
            raise <<-MSG
#{"*" * 80}
*  You are trying to run an rspec rake task defined in
*  #{__FILE__},
*  but rspec can not be found in vendor/gems, vendor/plugins or system gems.
#{"*" * 80}
MSG
          end
        end
      end
    end
  end
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

desc 'Test the csv builder'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern   = "./spec/**/*_spec.rb"
end

desc 'Default: run specs.'
task :default => :spec
