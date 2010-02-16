# encoding: utf-8
require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'
$:.unshift File.dirname(__FILE__)+'/rails'

require 'spec'
require 'action_controller'
require 'action_view'
require 'spec/rails'
require 'fastercsv'

Spec::Runner.configure do |config|
end

require File.expand_path(File.dirname(__FILE__) + '/../lib/csv_builder')
ActionView::Template.register_template_handler 'csvbuilder', ActionView::TemplateHandlers::CsvBuilder

TEST_DATA = [
  ['Lorem', 'ipsum'],
  ['Lorem ipsum dolor sit amet,' 'consectetur adipiscing elit. Sed id '],
  ['augue! "3" !@#$^&*()_+_', 'sed risus laoreet condimentum ac nec dui.'],
  ['\'Aenean sagittis lorem ac', 'lorem comm<s>odo nec eleifend risus']
]

def generate(options = {}, data = TEST_DATA)
  FasterCSV.generate(options) do |csv|
    data.each do |row|
      csv << row
    end
  end
end
