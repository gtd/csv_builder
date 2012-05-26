#encoding: utf-8

# Transliterate into the required encoding if necessary
#
# We can't rely on the encoding option in the Ruby 1.9 version CSV because this
# is ignored when it is 'compatible' (see <tt>Encoding.compatible?</tt>with the
# input for example:
#
#    CSV.generate(:encoding => 'ASCII') { |csv| '£12.34'.encoding('UTF-8') }
#
# will generate a UTF-8 encoded string.
class CsvBuilder::TransliteratingFilter
  # Transliterate into the required encoding if necessary
  def initialize(csv, input_encoding = 'UTF-8', output_encoding = 'ISO-8859-1')
    self.csv = csv

    if RUBY_VERSION.to_f < 1.9
      # TODO: do some checking to make sure iconv works correctly in
      # current environment. See <tt>ActiveSupport::Inflector#transliterate</tt>
      # definition for details
      #
      # Not using the more standard //IGNORE//TRANSLIT because it raises
      # <tt>Iconv::IllegalSequence,/tt> for some inputs
      self.iconv = Iconv.new("#{output_encoding}//TRANSLIT//IGNORE", input_encoding) if input_encoding != output_encoding
    else
      # <tt>input_encoding</tt> is ignored because we know what this it is
      self.output_encoding = output_encoding
    end
  end

  # Transliterate before passing to CSV so that the right characters
  # (e.g. quotes) get escaped
  def <<(row)
    @csv << convert_row(row)
  end
  alias :add_row :<<

  private
  attr_accessor :csv

  private
  if RUBY_VERSION.to_f < 1.9
    attr_accessor :iconv

    def convert_row(row)
      if iconv then row.map { |value| iconv.iconv(value.to_s) } else row end
    end
  else
    attr_accessor :output_encoding

    def convert_row(row)
      row.map { |value| value.to_s.encode(output_encoding, :undef => :replace) }
    end
  end
end
