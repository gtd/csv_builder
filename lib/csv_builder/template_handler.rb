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
  # These default to 'UTF-8' and 'ISO-8859-1' respectively. e.g.
  #
  #   @output_encoding = 'UTF-8'

  if defined?(Rails) and Rails.version < '3'
    class TemplateHandler < ActionView::Template::Handler
      include ActionView::Template::Handlers::Compilable
    end
  end

  # The ruby csv class will try to infer a separator to use, if the csv options
  # do not set it. ruby's csv calls pos, eof?, read, and rewind to check the first line
  # of the io to infer a separator. Rails' output object does not support these methods
  # so we provide a mock implementation to satisfy csv.
  #
  # See code at https://github.com/ruby/ruby/blob/trunk/lib/csv.rb#L2021 - note that @io points
  # to an object of this class.
  class Yielder
    def initialize(yielder)
      @yielder = yielder
    end

    # always indicate that we are at the start of the io stream
    def pos
      return 0
    end

    # always indicate that we have reached the end of the file
    def eof?
      return true
    end

    #do nothing, we haven't moved forward
    def rewind
    end

    #despite indicating that we have no data with pos and eof, we still need to return a newline
    #otherwise CSV will enter an infinite loop with read.
    def read(arg1)
      return "\n"
    end

    # this is the method that ultimately yields to the block with output.
    # the block is passed by Rails into the Streamer class' each method.
    # Streamer provides a Proc to this class, which simply invokes yield
    # from within the context of the each block.
    def <<(data)
      @yielder.call data
    end

  end

  # Streamer implements an each method to facilitate streaming back through the Rails stack. It requires
  # the template to be passed to it as a proc. An instance of this class is returned from the template handler's
  # compile method, and will receive calls to each. Data is streamed by yielding back to the containing block.
  class Streamer
    def initialize(template_proc)
      @template_proc = template_proc
    end

    def each
      yielder = CsvBuilder::Yielder.new(Proc.new{|data| yield data})
      csv_stream = CsvBuilder::CSV_LIB.new(yielder, @csv_options || {})
      csv = CsvBuilder::TransliteratingFilter.new(csv_stream, @input_encoding || 'UTF-8', @output_encoding || 'ISO-8859-1')
      @template_proc.call(csv)
    end
  end

  class TemplateHandler
    def self.call(template)

      <<-EOV
      begin

        unless defined?(ActionMailer) && defined?(ActionMailer::Base) && controller.is_a?(ActionMailer::Base)
          @filename ||= "\#{controller.action_name}.csv"
          if controller.request.env['HTTP_USER_AGENT'] =~ /msie/i
            response.headers['Pragma'] = 'must-revalidate'
            response.headers["Content-type"] = "text/plain"
            response.headers['Cache-Control'] = 'must-revalidate, post-check=0, pre-check=0'
            response.headers['Content-Disposition'] = "attachment; filename=\\"\#{@filename}\\""
            response.headers['Expires'] = "0"
          else
            response.headers["Content-Type"] ||= 'text/csv'
            response.headers["Content-Disposition"] = "attachment; filename=\\"\#{@filename}\\""
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
            csv = CsvBuilder::TransliteratingFilter.new(faster_csv, @input_encoding || 'UTF-8', @output_encoding || 'ISO-8859-1')
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

    def compile(template)
      self.class.call(template)
    end
  end
end
