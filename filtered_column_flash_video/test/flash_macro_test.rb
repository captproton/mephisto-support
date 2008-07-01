require File.join(File.dirname(__FILE__), 'abstract_unit')

class FlashMacroTest < Test::Unit::TestCase

  def test_should_retrieve_macro
    assert_equal FlashVideo, FilteredColumn.macros[:flash_macro]
  end

  def test_code_macro_with_language
    html = process_macros '<macro:flash>http://ralree.info/assets/2007/8/13/party.flv</macro:flash>'
    puts html
  end
  
  private
    def process_macros(text)
      FilteredColumn::Processor.new(nil, text).filter
    end
end
