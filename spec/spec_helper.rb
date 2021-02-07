# encoding: utf-8

ENV["RAILS_ENV"] ||= 'test'
rails_root = File.expand_path('../rails_app_5_2', __FILE__)
require rails_root + '/config/environment.rb'

require 'rspec/rails'

TEST_DATA = [
  ['Lorem', 'ipsum'],
  ['Lorem ipsum dolor sit amet,' 'consectetur adipiscing elit. Sed id '],
  ['augue! "3" !@#$^&*()_+_', 'sed risus laoreet condimentum ac nec dui.'],
  ['\'Aenean sagittis lorem ac', 'lorem comm<s>odo nec eleifend risus']
]

def generate(options = {}, data = TEST_DATA)
  CsvBuilder::CSV_LIB.generate(options) do |csv|
    data.each do |row|
      csv << row
    end
  end
end
