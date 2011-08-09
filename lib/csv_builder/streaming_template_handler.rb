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
    class StreamingTemplateHandler < ActionView::Template::Handler
      include ActionView::Template::Handlers::Compilable

      def compile(template)
        
        <<-EOV
        begin
             
          unless defined?(ActionMailer) && defined?(ActionMailer::Base) && controller.is_a?(ActionMailer::Base)
            @filename ||= "\#{controller.action_name}.csv"
            if controller.request.env['HTTP_USER_AGENT'] =~ /msie/i
              response.headers['Pragma'] = 'public'
              response.headers["Content-type"] = "text/plain"
              response.headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
              response.headers['Content-Disposition'] = "attachment; filename=\#{@filename}"
              response.headers['Expires'] = "0"
            else
              response.headers["Content-Type"] ||= 'text/csv'
              response.headers["Content-Disposition"] = "attachment; filename=\#{@filename}"
              response.headers["Content-Transfer-Encoding"] = "binary"
            end
          end
          
          return proc { |response, output| 
             
            output.class.send(:define_method, "pos") { return 0 }
            output.class.send(:define_method, "eof?") { return false }
            output.class.send(:define_method, "rewind") {}
            output.class.send(:define_method, "read") {|arg1|  return "\\n" }
            output.class.send(:define_method, "<<") {|arg1|   self.write(arg1)}
            csv_stream = CsvBuilder::CSV_LIB.new(output, @csv_options || {}) 
            csv = CsvBuilder::TransliteratingFilter.new(csv_stream, @input_encoding || 'UTF-8', @output_encoding || 'LATIN1')
            #{template.source}
          }
          return ""
        rescue Exception => e
          Rails.logger.warn("Exception \#{e} \#{e.message} with class \#{e.class.name} thrown when rendering CSV")
          raise e
        end
        EOV
      end
    end
end
