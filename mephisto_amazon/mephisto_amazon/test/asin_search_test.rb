require File.dirname(__FILE__) + '/test_helper'

class AsinSearchTest < Test::Unit::TestCase
    include FlexMock::TestCase
    
    def test_render  
      #mock out the search_delegate in the amazon_search tag
      mock_delegate = flexmock("delegate")
      tokens = ["123", "{% endasin_search %}"]
      tag = MephistoAmazon::AsinSearch.new("asin_search", "123", tokens)
      tag.view = MephistoAmazon::Test_Search_View
      tag.delegate = mock_delegate

      mock_response = flexmock("response")
      mock_response.should_receive(:asin).and_return("123456789")
      mock_response.should_receive(:image_url_small).and_return("foo.jpg")

      #the code to close the tag in Liquid reads from the tokens array, so we have to include it there, rather than the markup
      mock_delegate.should_receive(:asin_search).with("123").and_return(MephistoAmazon::ResponseDrop.new(mock_response))

      output = tag.render nil
    end
end