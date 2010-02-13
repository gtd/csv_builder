# encoding: utf-8
require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'
$:.unshift File.dirname(__FILE__)+'/rails'

require 'spec'
require 'action_controller'
require 'action_view'
require 'spec/rails'

Spec::Runner.configure do |config|
end

require File.expand_path(File.dirname(__FILE__) + '/../lib/csv_builder')
ActionView::Template.register_template_handler 'csvbuilder', ActionView::TemplateHandlers::CsvBuilder

