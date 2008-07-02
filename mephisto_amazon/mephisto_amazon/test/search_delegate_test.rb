require File.dirname(__FILE__) + '/test_helper'

require 'flexmock'

class SearchDelegateTest < Test::Unit::TestCase
          include FlexMock::TestCase

  class AsinFixture
    attr_reader :asin
    
    def initialize
      @asin = "foo"
    end
  end

  def test_mode_search
    searcher = MephistoAmazon::SearchDelegate.new()
    mock_request = flexmock('request')
    mock_response = flexmock('response')
    mock_response.should_receive(:products).and_return([AsinFixture.new])


    drop = MephistoAmazon::ResponseDrop.new AsinFixture.new
    mock_request.should_receive(:keyword_search).and_return(mock_response)
    #mock_request.should_receive(:keyword_search).with("eureka stockade", "Books").and_return(drop)
         
    searcher.request = mock_request
    result = searcher.search(MephistoAmazon::Books, "eureka stockade")
        
    assert_equal(drop.asin, "foo")
  end  

  def test_asin_search
    searcher = MephistoAmazon::SearchDelegate.new()
    mock_request = flexmock('request')
    mock_response = flexmock('response')
    mock_response.should_receive(:products).and_return(AsinFixture.new)


    drop = MephistoAmazon::ResponseDrop.new AsinFixture.new
    mock_request.should_receive(:asin_search).and_return(mock_response)
    #mock_request.should_receive(:keyword_search).with("eureka stockade", "Books").and_return(drop)
         
    searcher.request = mock_request
    result = searcher.asin_search("123")
        
    assert_equal(drop.asin, "foo")
  end 
end