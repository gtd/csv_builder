require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class CsvBuilderReportsController < ApplicationController
  before_filter {|c| c.prepend_view_path(File.expand_path(File.dirname(__FILE__) + '/../templates')) }

  def index
    respond_to do |format|
      format.html
      format.csv
    end
  end
end
ActionController::Routing::Routes.draw { |map| map.resources :csv_builder_reports }


describe CsvBuilderReportsController do
  integrate_views
  
  it "should still respond to HTML" do
    get 'index'
    response.should be_success
  end
  
  it "should respond to CSV" do
    get 'index', :format => 'csv'
    response.should be_success
  end
end
