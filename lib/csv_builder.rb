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
    # These default to 'UTF-8' and 'LATIN1' respectively. e.g.
    #
    #   @output_encoding = 'UTF-8'
    class CsvBuilder < TemplateHandler
      include Compilable

      def self.line_offset
        9
      end

      def compile(template)
        <<-EOV
        begin
          unless defined?(ActionMailer) && defined?(ActionMailer::Base) && controller.is_a?(ActionMailer::Base)
            @filename ||= "\#{controller.action_name}.csv"
            controller.response.headers["Content-Type"] ||= 'text/csv'
            controller.response.headers['Content-Disposition'] = "attachment; filename=\#{@filename}"
          end

          FasterCSV.generate do |faster_csv|
            csv = TransliteratingFilter.new(faster_csv)
            #{template.source}
          end
        rescue Exception => e
          RAILS_DEFAULT_LOGGER.warn("Exception \#{e} \#{e.message} with class \#{e.class.name} thrown when rendering CSV")
          raise e
        end
        EOV
      end
    end
  end
end
