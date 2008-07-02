require File.dirname(__FILE__) + '/../../lib/flickr_aggregation'

# This is a stub aggregator, replacing Mephisto's lib/flickr library
class FlickrAggregation
  def initialize(url)
  end
  
  def choose(number)
    pics = []
    pics << Picture.new
    pics
  end
end