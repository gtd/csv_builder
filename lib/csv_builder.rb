require 'fastercsv'

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

        result
        EOV
      end

    end
  end
end