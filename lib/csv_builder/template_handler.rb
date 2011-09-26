# encoding: utf-8

module CsvBuilder # :nodoc:

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
    class TemplateHandler
      def self.call(template)
        new.compile(template)
      end

      def compile(template)
        <<-EOV
        begin
          output = CsvBuilder::CSV_LIB.generate(@csv_options || {}) do |faster_csv|
            csv = CsvBuilder::TransliteratingFilter.new(faster_csv, @input_encoding || 'UTF-8', @output_encoding || 'LATIN1')
            #{template.source}
          end

          unless defined?(ActionMailer) && defined?(ActionMailer::Base) && controller.is_a?(ActionMailer::Base)
            @filename ||= "\#{controller.action_name}.csv"
            if controller.request.env['HTTP_USER_AGENT'] =~ /msie/i
              controller.response.headers['Pragma'] = 'public'
              controller.response.headers["Content-type"] = "text/plain"
              controller.response.headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
              controller.response.headers['Content-Disposition'] = "attachment; filename=\#{@filename}"
              controller.response.headers['Expires'] = "0"
            else
              controller.response.headers["Content-Type"] ||= 'text/csv'
              controller.response.headers["Content-Disposition"] = "attachment; filename=\#{@filename}"
              controller.response.headers["Content-Transfer-Encoding"] = "binary"
            end
          end

          output
        rescue Exception => e
          Rails.logger.warn("Exception \#{e} \#{e.message} with class \#{e.class.name} thrown when rendering CSV")
          raise e
        end
        EOV
      end
    end
end
