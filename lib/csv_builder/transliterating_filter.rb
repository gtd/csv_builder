#encoding: utf-8

class CsvBuilder::TransliteratingFilter
  # Transliterate into the required encoding if necessary
  def initialize(csv, input_encoding = 'UTF-8', output_encoding = 'ISO-8859-1')
    self.csv = csv

    # TODO: do some checking to make sure iconv works correctly in
    # current environment. See ActiveSupport::Inflector#transliterate
    # definition for details
    #
    # Not using the more standard //IGNORE//TRANSLIT because it raises
    # Iconv::IllegalSequence for some inputs
    self.iconv = Iconv.new("#{output_encoding}//TRANSLIT//IGNORE", input_encoding) if input_encoding != output_encoding
  end

  # Transliterate before passing to FasterCSV so that the right characters (e.g. quotes) get escaped
  def <<(row)
    csv << if iconv then row.map { |value| iconv.iconv(value.to_s) } else row end
  end

  alias :add_row :<<

  private
  attr_accessor :csv, :iconv
end
