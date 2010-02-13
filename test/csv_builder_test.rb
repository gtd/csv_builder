require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_support/test_case'
require 'action_controller'
require 'action_controller/test_process'
require 'action_view/test_case'
require File.join(File.dirname(__FILE__), '..', 'rails', 'init') 

module ActionView
  class Base
    module CompiledTemplates
      RAILS_DEFAULT_LOGGER = Logger.new('test.log')
    end
  end
end

class CsvBuilderReportsController < ActionController::Base
  before_filter {|c| c.prepend_view_path(File.join(File.dirname(__FILE__), 'templates')) }

  def index
    respond_to do |format|
      format.html
      format.csv
    end
  end
end

ActionController::Routing::Routes.draw { |map| map.resources :csv_builder_reports }

class CsvBuilderTest < ActionController::TestCase
  def setup
    @controller = CsvBuilderReportsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  test "should render html template" do
    get :index
    assert_response :success
  end
  
  test "should render csv template" do
    get :index, :format => 'csv'
    assert_response :success
  end
end

