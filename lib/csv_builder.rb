require 'fastercsv'
require 'iconv'

module ActionView # :nodoc:
  module TemplateHandlers
    # Template handler for csv templates
    #
    # Add rows to your CSV file in the template by pushing arrays of columns into csv
    #
    #   # First row
    #   csv << [ 'cell 1', 'cell 2' ]
    #   # Second row
    #   csv << [ 'another cell value', 'and another' ]
    #   # etc...
    #
    # You can set the default filename for that a browser will use for 'save as' by
    # setting <tt>@filename</tt> instance variable in your controller's action method
    # e.g.
    #
    #   @filename = 'report.csv'
    #
    # You can also set the input encoding and output encoding by setting
    # <tt>@input_encoding</tt> and <tt>@output_encoding</tt> instance variables.
    # These default to 'utf-8' and 'latin1' respectively. e.g.
    #
    #   @output_encoding = 'utf-8'
    
    class CsvBuilder < TemplateHandler

      include Compilable

      def self.line_offset
        7
      end

      def compile(template)
        <<-EOV
        unless defined?(ActionMailer) && defined?(ActionMailer::Base) && controller.is_a?(ActionMailer::Base)
          @filename ||= "\#{controller.action_name}.csv"
          controller.response.headers["Content-Type"] ||= 'text/csv'
          controller.response.headers['Content-Disposition'] = "attachment; filename=\#{@filename}"
        end

        result = FasterCSV.generate do |csv|
          #{template.source}
        end

        # Transliterate into the required encoding if necessary
        # TODO: make defaults configurable
        @input_encoding ||= 'utf-8'
        @output_encoding ||= 'latin1'

        if @input_encoding == @output_encoding
          result
        else
          # TODO: do some checking to make sure iconv works correctly in current environment
          # See ActiveSupport::Inflector#transliterate definition for details
          Iconv.iconv("\#{@output_encoding}//ignore//translit", @input_encoding, result).to_s
        end

        EOV
      end

    end
  end
end
