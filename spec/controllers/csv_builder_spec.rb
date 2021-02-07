#encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class CsvBuilderReportsController < ApplicationController
  before_action {|c| c.prepend_view_path(File.expand_path(File.dirname(__FILE__) + '/../templates')) }

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

Rails.application.routes.draw do
  get 'csv_builder_reports/simple', to: 'csv_builder_reports#simple'
  get 'csv_builder_reports/complex', to: 'csv_builder_reports#complex'
  get 'csv_builder_reports/encoding', to: 'csv_builder_reports#encoding'
  get 'csv_builder_reports/massive', to: 'csv_builder_reports#massive'
end


describe CsvBuilderReportsController, type: :controller do
  render_views

  describe "Simple layout" do
    it "still responds to HTML" do
      get 'simple'
      expect(response).to be_success
    end

    it "responds to CSV" do
      get 'simple', :format => 'csv'
      expect(response).to be_success
    end
  end

  describe "Layout with options" do
    describe "output encoding" do
      let(:expected_utf8) { generate({}, [['£12.34', 'ąčęėįšųūž', 'foo']]) }

      if RUBY_VERSION.to_f < 1.9 && RUBY_PLATFORM.match(/darwin/)
        # iconv appears to have more transliteration built into it on OSX than
        # other platforms and so does a 'better' job of converting to ASCII
        let(:expected_ascii) { generate({}, [['lb12.34' ,'aceeisuuz', 'foo']]) }
      else
        let(:expected_ascii) { generate({}, [['?12.34' ,'?????????', 'foo']]) }
      end

      it "transliterates to ASCII when required" do
        get 'encoding', params: {format: 'csv', encoding: 'ASCII'}
        expect(response.body.to_s).to eq(expected_ascii)
      end

      it "keeps output in UTF-8 when required" do
        get 'encoding', params: {format: 'csv', encoding: 'UTF-8'}
        expect(response.body.to_s).to eq(expected_utf8)
      end
    end

    it "passes csv options" do
      get 'complex', :format => 'csv'
      expect(response.body.to_s).to eq(generate(col_sep: "\t" ))
    end

    it "sets filename" do
      get 'complex', :format => 'csv'
      expect(response.headers['Content-Disposition']).to match(/filename="some_complex_filename.csv"/)
    end

    #TODO: unfortunately, this test only verifies that streaming will behave like single-shot response, because rspec's testresponse doesn't
    #support streaming. Streaming has to be manually verified with a browser and stand-alone test application. see https://github.com/fawce/test_csv_streamer
    it "handles very large downloads without timing out" do
      get 'massive', :format => 'csv'
      expect(response.body.to_s.length).to eq(24890)
    end
  end
end
