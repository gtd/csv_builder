#encoding: utf-8

class CsvBuilder::StreamingTransliteratingFilter
  # Transliterate into the required encoding if necessary
  def initialize(faster_csv, input_encoding = 'UTF-8', output_encoding = 'LATIN1')
    @faster_csv = faster_csv
    @output = output
    # TODO: do some checking to make sure iconv works correctly in
    # current environment. See ActiveSupport::Inflector#transliterate
    # definition for details
    #
    # Not using the more standard //IGNORE//TRANSLIT because it raises
    # Iconv::IllegalSequence for some inputs
    @iconv = Iconv.new("#{output_encoding}//TRANSLIT//IGNORE", input_encoding) if input_encoding != output_encoding
  end

  # Transliterate before passing to FasterCSV so that the right characters (e.g. quotes) get escaped
  # immediately write this row
  def <<(row)
    arr = (if @iconv then row.map { |value| @iconv.iconv(value.to_s) } else row end).to_csv
    row = @faster_csv.generate_line(arr)
    @faster_csv.add_row(row)
  end

  alias :add_row :<<
end
