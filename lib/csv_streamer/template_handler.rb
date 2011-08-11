# encoding: utf-8

module CsvBuilder # :nodoc:
  
  class Yielder
    def initialize(stream_proc)
      @stream_proc = stream_proc
    end
    
    def pos
      return 0
    end
    
    def eof?
      return true
    end
    
    def rewind
    end
    
    def read(arg1)
      return "\n"
    end
    
    def <<(data)
      @stream_proc.call data
    end
    
  end
  
  class Streamer
    def initialize(template_proc)
      @template_proc = template_proc
    end
    
    def each
      # The ruby csv class will try to infer a separator to use, if the csv options
      # do not set it. ruby's csv calls pos, eof?, read, and rewind to check the first line
      # of the io to infer a separator. Rails' output object does not support these methods
      # so we provide a mock implementation to satisfy csv.
      #
      # See code at https://github.com/ruby/ruby/blob/trunk/lib/csv.rb#L2021 - note that @io points
      # to the output variable defined by this block.
      # output.class.send(:define_method, "pos") {return 0 }
      # output.class.send(:define_method, "eof?") { return true }
      # output.class.send(:define_method, "rewind") {}
      # read needs to return a newline, otherwise csv loops indefinitely looking for the end of the first line.
      # output.class.send(:define_method, "read") {|arg1| return "\\n" }
      # output = ""                                      
      # The ruby csv write method requires output to support << for writing. Here we just 
      # delegate the method call to output's write method.
      # output.class.send(:define_method, "<<") {|arg1| yield arg1}
      
      yielder = CsvBuilder::Yielder.new(Proc.new{|data| yield data})
      csv_stream = CsvBuilder::CSV_LIB.new(yielder, @csv_options || {}) 
      csv = CsvBuilder::TransliteratingFilter.new(csv_stream, @input_encoding || 'UTF-8', @output_encoding || 'LATIN1')
      @template_proc.call(csv)
    end
end
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
          
          if @streaming
            template = Proc.new {|csv|
              #{template.source}
            }
            CsvBuilder::Streamer.new(template)
          else 
            output = CsvBuilder::CSV_LIB.generate(@csv_options || {}) do |faster_csv|
              csv = CsvBuilder::TransliteratingFilter.new(faster_csv, @input_encoding || 'UTF-8', @output_encoding || 'LATIN1')
              #{template.source}
            end
            output
          end
        rescue Exception => e
          Rails.logger.warn("Exception \#{e} \#{e.message} with class \#{e.class.name} thrown when rendering CSV")
          raise e
        end
        EOV
      end
    end
end
