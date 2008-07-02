require File.dirname(__FILE__) + '/test_helper'

class KeywordSearchTest < Test::Unit::TestCase
    include FlexMock::TestCase

  def test_render_parse_instruction
 
   #mock out the search_delegate in the amazon_search tag
   mock_delegate = flexmock("delegate")
   tokens = ["Books","ulysses", "{% endkeyword_search %}"]
   tag = MephistoAmazon::KeywordSearch.new("keyword_search", "Books ulysses", tokens)
   tag.view = MephistoAmazon::Test_Search_View
   tag.delegate = mock_delegate
   
   mock_response = flexmock("response")
   mock_response.should_receive(:asin).and_return("123456789")
   mock_response.should_receive(:image_url_small).and_return("foo.jpg")

   mock_response2 = flexmock("response")
   mock_response2.should_receive(:asin).and_return("abcdef")
   mock_response2.should_receive(:image_url_small).and_return("foo2.jpg")

   
   #the code to close the tag in Liquid reads from the tokens array, so we have to include it there, rather than the markup
   mock_delegate.should_receive(:search).with("books", "ulysses").and_return([MephistoAmazon::ResponseDrop.new(mock_response),MephistoAmazon::ResponseDrop.new(mock_response2) ])
        
   output = tag.render nil
   assert_equal("\nasin: 123456789\nimage: foo.jpg\n\nasin: abcdef\nimage: foo2.jpg\n\n", output )
  end
end