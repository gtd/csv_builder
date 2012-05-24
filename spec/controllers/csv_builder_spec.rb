#encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class CsvBuilderReportsController < ApplicationController
  before_filter {|c| c.prepend_view_path(File.expand_path(File.dirname(__FILE__) + '/../templates')) }

  def simple
    # dummy
    respond_to do |format|
      format.html
      format.csv
    end
  end

  def complex
    respond_to do |format|
      format.csv do
        @filename = 'some_complex_filename.csv'
        @csv_options = { :col_sep => "\t" }
        @data = TEST_DATA
      end
    end
  end

  def encoding
    respond_to do |format|
      format.csv { @output_encoding = params[:encoding] }
    end
  end

  def massive
    respond_to do |format|
      @streaming = true
      format.csv
    end
  end

end

if defined?(Rails) and Rails.version < '3'
  ActionController::Routing::Routes.draw { |map| map.connect ':controller/:action' }
else
  Rails.application.routes.draw { get ':controller/:action' }
end


describe CsvBuilderReportsController do
  render_views

  describe "Simple layout" do
    it "still responds to HTML" do
      get 'simple'
      response.should be_success
    end

    it "responds to CSV" do
      get 'simple', :format => 'csv'
      response.should be_success
    end
  end

  describe "Layout with options" do
    describe "output encoding" do
      it "transliterates to ASCII when required" do
        get 'encoding', :format => 'csv', :encoding => 'ASCII'
        correct_output = generate({}, [['aceeisuuz']])
        response.body.to_s.should == correct_output
      end

      it "keeps output in UTF-8 when required" do
        get 'encoding', :format => 'csv', :encoding => 'UTF-8'
        correct_output = generate({}, [['ąčęėįšųūž']])
        response.body.to_s.should == correct_output
      end
    end

    it "passes csv options" do
      get 'complex', :format => 'csv'
      response.body.to_s.should == generate({ :col_sep => "\t" })
    end

    it "sets filename" do
      get 'complex', :format => 'csv'
      response.headers['Content-Disposition'].should match(/filename="some_complex_filename.csv"/)
    end

    #TODO: unfortunately, this test only verifies that streaming will behave like single-shot response, because rspec's testresponse doesn't
    #support streaming. Streaming has to be manually verified with a browser and stand-alone test application. see https://github.com/fawce/test_csv_streamer
    it "handles very large downloads without timing out" do
      get 'massive', :format => 'csv'
      response.body.to_s.length.should == 24890
    end
  end
end
